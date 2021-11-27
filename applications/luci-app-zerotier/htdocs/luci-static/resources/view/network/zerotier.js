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
    o.default = '1';
    o.rmempty = false;

    o = s.option(form.Value, 'port', _('Port'));
    o.default = '9993';

    o = s.option(form.DynamicList, 'join', _('Networks'));

    return m.render();
  },
});
