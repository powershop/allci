Application.Components.Labels = {
  view: function({ attrs }) {
    const { labels } = attrs
    return m(
      'section.labels',
      m('h3', 'Labels'),
      m('ul', labels.map(label => m(Label, { label })))
    )
  }
}

const Label = {
  view: function({ attrs }) {
    const { label } = attrs
    return m(
      'li',
      m('label',
        m('input', { type: 'checkbox' }),
        m('span', label)
      )
    )
  }
}
