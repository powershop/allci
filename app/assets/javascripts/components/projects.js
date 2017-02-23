Application.Components.Projects = {
  view: function({ attrs }) {
    const { projects } = attrs
    return m(
      'section.projects',
      m('h3', 'Projects'),
      m('ul', projects.map(project => m(Project, { project })))
    )
  }
}

const Project = {
  view: function({ attrs }) {
    const { project } = attrs
    return m(
      'li',
      project
    )
  }
}
