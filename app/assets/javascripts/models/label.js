Application.Models.Label = {
  list: [],
  byId: {},
  loadList: function() {
    m.request({
      url: `/labels?_=${new Date().getTime()}`,
      method: 'get'
    })
    .then(function(list) {
      Application.Models.Label.list = list
      Application.Models.Label.byId = list.reduce(function(hash, label) {
        hash[label.id] = label
        return hash
      }, {})
    })
  },
  toggle: (id, selected) => Application.Models.Label.byId[id].selected = selected,
  selected: () => Application.Models.Label.list.filter(label => label.selected)
}
