window.onload = function(){
  
  new Vue({
    el: '#tasks',
    data: {
      tasks: undefined,
      deadClosedTasks: undefined,
      params: {
        task: {
          title: undefined,
          status: undefined,
          priority: undefined,
          responsible: undefined,
          user: undefined,
          labels: undefined,
        }
      }
    },
    created: function() {
      this.default_search();
    },
    methods: {
      default_search: function() {
        var self = this;
        $.ajax({
          url: "tasks.json",
          method: "GET",
          headers: {
            'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')
          },
        }).then(function (response) {
          self.tasks = response.tasks;
          self.deadClosedTasks = response.close_dead_tasks;
        });
      },
      search: function() {
        var self = this;
        $.ajax({
          url: "tasks.json",
          method: "GET",
          data: {
            task: self.params.task,
          },
          headers: {
            'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')
          },
        }).then(function (response) {
          self.tasks = response.tasks;
          self.deadClosedTasks = response.close_dead_tasks;
        });
      },
      reset: function() {
        this.default_search();
        $('input').val('');
        $('select').val('');
      },
      collectComplete: function() {
        var task_ids = $('input[name="task_id"]:checked').map(function(){
          return $(this).val();
        }).get();
  
        $.ajax({
          url: '/api/tasks/' + task_ids[0],
          type: 'PATCH',
          data: {
            task_ids: task_ids
          },
          headers: {
            'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')
          },
        }).then(function (response) {
          console.log(response);
           // toastr.success();
        }).fail(function (response) {
          // toastr.error(data.message);
        })
      }
    }
  })
  
};
