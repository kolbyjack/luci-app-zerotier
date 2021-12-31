'use strict';
'require form';
'require fs';
'require uci';
'require view';

return view.extend({
  render: function() {
    var m, s, o;

    m = new form.Map('zerotier', _('ZeroTier Settings'));
    m.anonymous = true;

    s = m.section(form.TypedSection, 'zerotier');
    s.anonymous = true;

    o = s.option(form.Flag, 'enabled', _('Enabled'));
    o.default = '0';
    o.rmempty = false;

    o = s.option(form.Flag, '_config_path', _('Persist Configuration for ZT controller mode'));
    o.rmempty = false;
    o.cfgvalue = function(section_id) {
      return !!uci.get('zerotier', section_id, 'config_path');
    };
    o.write = function(section_id, form_value) {
      let config_path = (!!+form_value) ? `/etc/config/zerotier-${sfh(section_id)}.d` : null;
      if (config_path !== null) {
        fs.exec('/bin/mkdir', ['-p', config_path]);
      }
      uci.set('zerotier', section_id, 'config_path', config_path);
    };

    o = s.option(form.Value, 'port', _('Port'));
    o.default = '9993';

    s.option(form.DynamicList, 'join', _('Networks'));

    return m.render();
  },
});
