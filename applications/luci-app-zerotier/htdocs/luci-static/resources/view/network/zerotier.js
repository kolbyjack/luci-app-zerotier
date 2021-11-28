'use strict';
'require view';
'require form';

return view.extend({
  render: function() {
    var m, s, o;

    m = new form.Map('zerotier', _('ZeroTier'));

    s = m.section(form.TypedSection, 'zerotier');
    s.addremove = true;

    o = s.option(form.Flag, 'enabled', _('Enabled'));
    o.default = '0';
    o.rmempty = false;

    s.option(form.Value, 'port', _('Port'));

    s.option(form.DynamicList, 'join', _('Networks'));

    return m.render();
  },
});
