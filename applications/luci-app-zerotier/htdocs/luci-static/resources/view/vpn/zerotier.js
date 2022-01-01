'use strict';
'require form';
'require fs';
'require poll';
'require uci';
'require view';

return view.extend({
  render: function() {
    let m, s, o;

    m = new form.Map('zerotier', _('ZeroTier'));
    m.anonymous = true;

    s = m.section(form.TypedSection, 'zerotier');
    s.anonymous = true;

    o = s.option(form.DummyValue, '_status', _('Status'));
    o.render = function(section_id) {
      let status_div = E('div', { 'class': 'cbi-value-field' }, _('Loading...'));

      poll.add(function() {
        return L.resolveDefault(fs.exec('/usr/bin/zerotier-cli', ['-j', 'info'])).then(function(status) {
          let text = _('NOT RUNNING');
          let version = '';
          let color = 'red';

          try {
            status = JSON.parse(status.stdout);
            version = `v${status.version} `;
            if (status.online) {
              text = _('ONLINE');
              color = 'green';
            } else {
              text = _('OFFLINE');
              color = 'goldenrod';
            }
          } catch {
          }

          status_div.innerText = `${version}${text}`;
          status_div.style.color = color;
        });
      });

      return E('div', { 'class': 'cbi-value' }, [
        E('label', { 'class': 'cbi-value-title' }, _('Status')),
        status_div
      ]);
    };
    o.write = function(section_id, form_value) {
    };

    o = s.option(form.Flag, 'enabled', _('Enabled'));
    o.default = '0';
    o.rmempty = false;

    o = s.option(form.Flag, '_config_path', _('Persist configuration for controller mode'));
    o.rmempty = false;
    o.cfgvalue = function(section_id) {
      return !!uci.get('zerotier', section_id, 'config_path');
    };
    o.write = function(section_id, form_value) {
      let config_path = (!!+form_value) ? `/etc/zerotier.d/${section_id}.d` : null;
      if (config_path !== null) {
        fs.exec('/bin/mkdir', ['-p', config_path]);
      }
      uci.set('zerotier', section_id, 'config_path', config_path);
    };

    o = s.option(form.Flag, 'copy_config_path', _('Copy config to RAM to avoid writing to flash'));
    o.depends('_config_path', '1');

    o = s.option(form.Value, 'port', _('Port'));
    o.default = '9993';

    s.option(form.DynamicList, 'join', _('Networks'));

    return m.render();
  },
});
