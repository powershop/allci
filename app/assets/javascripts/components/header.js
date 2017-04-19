Application.Components.Header = {
  view: function({ attrs }) {
    const { user } = attrs
    return m(
      'header',
      m('a.logo', { href: '/' }, 'All C-ing I'),
      m('a.user', { href: '#' }, user.name)
    )
  }
}
