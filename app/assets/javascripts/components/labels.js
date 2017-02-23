const { Label } = Application.Models

Application.Components.Labels = {
  selected: [],

  oninit: Label.loadList,

  view: function({ attrs }) {
    const { labels } = attrs
    return m(
      'section.labels',
      m('h3', 'Labels'),
      m(
        'ul',
        Label.list.map(label => m(Application.Components.Label, { label }))
      )
    )
  }
}

Application.Components.Label = {
  view: function({ attrs }) {
    const { label } = attrs
    const { name, id, selected } = label
    return m(
      'li',
      m('label',
        m(
          'input',
          {
            type: 'checkbox',
            checked: selected,
            onchange: m.withAttr('checked', checked => Label.toggle(id, checked))
          }
        ),
        m('span', name)
      )
    )
  }
}
