window.onload = function(){
  
  new Vue({
    el: '#tasks-calendar',
    data: {
      isClick: false,
      year: '',
      month: '',
      start_week: '',
      weekList: ['日', '月', '火', '水', '木', '金', '土'],
      days: [],
      calendar_dates: [],
      month_tasks: [],
      select_tasks: [],
    },
    created: function() {
      var self = this;
      var now         = new Date();
      this.year       = now.getFullYear();
      this.month      = now.getMonth() + 1;
      this.start_week = new Date(this.year, this.month -1, 1).getDay();
      var end_date    = new Date(this.year, this.month, 0);
      this.days        = Array.from(new Array(end_date.getDate())).map((v,i)=> i + 1);
  
      this.setDates();
      
      // axios.get('/tasks/calendar.json', {
      //   params: {
      //     start_day: this.year + '-' + this.month + '-1',
      //     end_day: this.year + '-' + this.month + '-' + end_date.getDate(),
      //   }
      // }).then(function (response) {
      //   var month_tasks = [];
      //   for ( var i = 0; i < self.dates.length; i++ ) {
      //     console.log('うんこ');
      //     // if ( response.data[i] !== 'undefined' ) {
      //     //   month_tasks.push(response.data[i]);
      //     // }
      //   }
      //   self.month_tasks = month_tasks;
      //   console.log(self.month_tasks);
      // });
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
        this.setDates();
      },
      getTasks: function(day) {
        var self = this;
        self.isClick = true;
        axios.get('/tasks/calendar.json', {
          params: {
            deadline_on: this.year + '-' + this.month + '-' + day,
          }
        }).then(function (response) {
          var select_tasks = [];
          for ( var i = 0; i < response.data.length; i++ ) {
            select_tasks.push(response.data[i]);
          };
          self.select_tasks = select_tasks;
        });
      },
      setDates: function() {
        var self = this;
        self.calendar_dates = [];
        dates = [];
        for ( var i = 0; i < this.days.length; i++ ) {
          var week_num = new Date(this.year, this.month -1, this.days[i]).getDay();
          dates.push({week: week_num, day: this.days[i]});
        };
        for ( var i = 0; i < this.start_week; i++) {
          dates.unshift({week: '', day: ''});
        };
        self.calendar_dates = dates;
      }
    }
  })
  
};

