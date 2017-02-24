(function() {
  Application.Components.Layout = {
    view: function({ children }) {
      const { Header, Labels, Projects, Build } = Application.Components

      return [
        m(Header, { user: { name: 'Hermione Granger' } }),
        m(
          'main',
          m(Labels),
          m(Projects),
          m(Build, ...children)
        )
      ]
    }
  }
})()
