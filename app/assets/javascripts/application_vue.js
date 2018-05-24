window.onload = function(){
  
  new Vue({
    el: '#tasks-calendar',
    data: {
      year: '',
      month: '',
      day: '',
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
  
      // 月の全タスクを取得してcalendar_tasksにセット
      axios.get('/tasks/calendar.json', {
        params: {
          start_day: self.year + '-' + self.month + '-1',
          end_day: self.year + '-' + self.month + '-' + new Date(self.year, self.month, 0).getDate(),
        }
      }).then(function (response) {
        self.setCalendarDates(response.data); // カレンダーで表示させる配列をモデルにセット
      });
    },
    methods: {
      shift: function(val) {
        var self = this;
        if (val === 'back') {
          self.month = (self.month === 1)?12:self.month -1;
          self.year = (self.month === 1)?self.year -1:self.year;
        } else {
          self.month = (self.month === 12)?1:self.month + 1;
          self.year = (self.month === 1)?self.year + 1:self.year;
        };
        
        axios.get('/tasks/calendar.json', {
          params: {
            start_day: self.year + '-' + self.month + '-1',
            end_day: self.year + '-' + self.month + '-' + new Date(self.year, self.month, 0).getDate(),
          }
        }).then(function (response) {
          self.setCalendarDates(response.data); // カレンダーで表示させる配列をモデルのセット
        });
      },
      
      getTasks: function(day) {
        var self = this;
        
        self.day = day;
        axios.get('/tasks/calendar.json', {
          params: {
            deadline_on: self.year + '-' + self.month + '-' + day,
          }
        }).then(function (response) {
          var select_tasks = [];
          for ( var i = 0; i < response.data.length; i++ ) {
            select_tasks.push(response.data[i]);
          };
          self.select_tasks = select_tasks;
        });
      },
      
      setCalendarDates: function(data) {
        var self = this;
        
        self.start_week = new Date(self.year, self.month -1, 1).getDay(); //初日と曜日を合わせるために必要
        var end_date    = new Date(self.year, self.month, 0); // 月の最終日
        self.days       = Array.from(new Array(end_date.getDate())).map((v,i)=> i + 1); // 月の日数の配列
        
        self.calendar_dates = [];
        var dates = [];
        for ( var i = 0; i < self.days.length; i++ ) {
          var week_num = new Date(self.year, self.month -1, self.days[i]).getDay();
          var tasks = data.filter(function(item, index) {
            if ( item.deadline_on ==  self.year + '-' + self.month + '-' + self.days[i]) return true;
          });
          dates.push({week: week_num, day: self.days[i], task_size: tasks.length + '件'});
        };
        for ( var i = 0; i < self.start_week; i++) {
          dates.unshift({week: '', day: ''});
        };
        
        self.calendar_dates = dates;
      }
    }
  })
  
};

