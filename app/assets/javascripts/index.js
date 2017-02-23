const { Header, Labels, Projects, Build } = Application.Components

Application.Components.Application = {
  view: function() {
    return [
      m(Header, { user: { name: 'Hermione Granger' } }),
      m(
        'main',
        m(Labels, { labels: ['Harry', 'Hermione', 'Ron', 'Draco'] }),
        m(Projects),
        m(Build)
      )
    ]
  }
}

m.mount(document.body, Application.Components.Application)
