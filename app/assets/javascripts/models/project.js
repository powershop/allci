Application.Models.Project = {
  list: [],
  byId: {},
  loadList: function() {
    m.request({
      url: `/projects?_=${new Date().getTime()}`,
      method: 'get'
    })
    .then(function(list) {
      Application.Models.Project.list = list
      Application.Models.Project.byId = list.reduce(function(hash, project) {
        hash[project.id] = project
        return hash
      }, {})
    })
  },
  find: (id) => Application.Models.Project.byId[id],
  visible: function() {
    const { Label, Project } = Application.Models
    const labels = Label.selected()
    const labelIds = labels.map(l => l.id)

    if (labels.length) {
      return Project.list.filter(function(project) {
        return project.labels.filter(l => labelIds.indexOf(l.id) > -1).length > 0
      })
    } else {
      return Project.list
    }
  }
}
