(function() {
  const { Layout, Project, BuildInformation } = Application.Components

  m.route.prefix('')

  m.route(document.body, '/projects', {
    '/projects/:id': {
      render: ({ attrs }) => m(Layout, m(BuildInformation, { project: Application.Models.Project.find(attrs.id) }))
    },
    '/projects': {
      render: () => m(Layout)
    }
  })
})()
