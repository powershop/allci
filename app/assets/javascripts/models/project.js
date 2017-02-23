Application.Models.Project = {
  list: [],
  loadList: function() {
    m.request({
      url: '/projects',
      method: 'get'
    })
    .then(list => Application.Models.Project.list = list)
  }
}
