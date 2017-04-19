(function () {
  Application.Components.Build = {
    view: function({ attrs, children }) {
      const { build } = attrs
      return m(
        'section.build-information',
        children.length ? children : m('.empty', 'Select a project')
      )
    }
  }

  Application.Components.BuildInformation = {
    view: function({ attrs, children }) {
      return m(
        'div',
        JSON.stringify(attrs)
      )
    }
  }
})()
