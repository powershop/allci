Application.Models.Project = {
  list: [],
  loadList: function() {
    m.request({
      url: '/projects',
      method: 'get'
    })
    .then(list => Application.Models.Project.list = list)
  },
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
