window.onload = function(){
  
  new Vue({
    el: '#calendar',
    data: {
      isClick: false,
      year: '',
      month: '',
      start_week: '',
      weekList: ['日', '月', '火', '水', '木', '金', '土'],
      dates: [],
      tasks: [],
    },
    created: function() {
      var now         = new Date();
      this.year       = now.getFullYear();
      this.month      = now.getMonth() + 1;
      this.start_week = new Date(this.year, this.month -1, 1).getDay();
      var end_date    = new Date(this.year, this.month, 0);
      var days        = Array.from(new Array(end_date.getDate())).map((v,i)=> i + 1);
      

      for ( var i = 0; i < days.length; i++ ) {
        var week_num = new Date(this.year, this.month -1, days[i]).getDay();
        this.dates.push({week: week_num, day: days[i]});
      };
      for ( var i = 0; i < this.start_week; i++) {
        this.dates.unshift({week: '', day: ''});
      };
    },
    methods: {
      shift: function(val) {
        if (val === 'back') {
          this.month = (this.month === 1)?12:this.month -1;
          this.year = (this.month === 1)?this.year -1:this.year;
        } else {
          this.month = (this.month === 12)?1:this.month + 1;
          this.year = (this.month === 1)?this.year + 1:this.year;
        }
        
        this.start_week = new Date(this.year, this.month -1, 1).getDay();
        var end_date    = new Date(this.year, this.month, 0);
        var days        = Array.from(new Array(end_date.getDate())).map((v,i)=> i + 1);
        this.dates = [];
        for ( var i = 0; i < days.length; i++ ) {
          var week_num = new Date(this.year, this.month -1, days[i]).getDay();
          this.dates.push({week: week_num, day: days[i]});
        };
        for ( var i = 0; i < this.start_week; i++) {
          this.dates.unshift({week: '', day: ''});
        };
      },
      getTasks: function(day) {
        var self = this;
        self.isClick = true;
        axios.get('/tasks/calendar.json', {
          params: {
            date: '"' + this.year + '-' + this.month + '-' + day + '"',
          }
        }).then(function (response) {
          var tasks = [];
          for ( var i = 0; i < response.data.length; i++ ) {
            tasks.push(response.data[i]);
          }
          self.tasks = tasks;
        })
      }
    }
  })
  
};

