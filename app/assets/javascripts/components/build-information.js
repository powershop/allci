Application.Components.Build = {
  view: function({ attrs }) {
    const { build } = attrs
    return m(
      'section.build-information',
      build ? m(BuildInformation, { build }) : m('.empty', 'Select a project')
    )
  }
}
