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
  
      // 以下月の全タスク
      axios.get('/tasks/calendar.json', {
        params: {
          start_day: this.year + '-' + this.month + '-1',
          end_day: this.year + '-' + this.month + '-' + new Date(this.year, this.month, 0).getDate(),
        }
      }).then(function (response) {
        self.setCallendarDates(response.data); // カレンダーで表示させる配列をモデルにセット
      });
    },
    methods: {
      shift: function(val) {
        var self = this;
        if (val === 'back') {
          this.month = (this.month === 1)?12:this.month -1;
          this.year = (this.month === 1)?this.year -1:this.year;
        } else {
          this.month = (this.month === 12)?1:this.month + 1;
          this.year = (this.month === 1)?this.year + 1:this.year;
        };
        
        axios.get('/tasks/calendar.json', {
          params: {
            start_day: this.year + '-' + this.month + '-1',
            end_day: this.year + '-' + this.month + '-' + new Date(this.year, this.month, 0).getDate(),
          }
        }).then(function (response) {
          self.setCallendarDates(response.data); // カレンダーで表示させる配列をモデルのセット
        });
      },
      
      getTasks: function(day) {
        var self = this;
        this.isClick = true;
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
      
      setCallendarDates: function(data) {
        var self = this;
        this.start_week = new Date(this.year, this.month -1, 1).getDay(); //初日と曜日を合わせるために必要
        var end_date    = new Date(this.year, this.month, 0); // 月の最終日
        this.days       = Array.from(new Array(end_date.getDate())).map((v,i)=> i + 1); // 月の日数の配列
        
        this.calendar_dates = [];
        var dates = [];
        for ( var i = 0; i < this.days.length; i++ ) {
          var week_num = new Date(this.year, this.month -1, this.days[i]).getDay();
          var tasks = data.filter(function(item, index) {
            if ( item.deadline_on ==  self.year + '-' + self.month + '-' + self.days[i]) return true;
          });
          dates.push({week: week_num, day: this.days[i], task_size: tasks.length + '件'});
        };
        for ( var i = 0; i < this.start_week; i++) {
          dates.unshift({week: '', day: ''});
        };
        this.calendar_dates = dates;
      }
    }
  })
  
};

