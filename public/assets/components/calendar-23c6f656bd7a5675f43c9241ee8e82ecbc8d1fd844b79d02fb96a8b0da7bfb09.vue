<template>
    <div id="calendar">
        <div class="flex.main">
            <div class="shift-button col-sm-3">
                <div class="btn default-btn" v-on:click="shif('back')">
                    <i class="fas fa-fa-chevron-left"></i>
                </div>
            </div>
        </div>
        <div class="month-year-info col-sm-6">
            <p class="text-center">
                <label>{{year}}年{{月}}</label>
            </p>
        </div>
        <div class="shift-button col-sm-3">
            <div class="btn default-btn pull-right" v-on:click="shift('next')">
                <i class="fas fa-chevron-right"></i>
            </div>
        </div>
        <table class="table">
            <thead>
            <tr>
                <th>日</th>
                <th>月</th>
                <th>火</th>
                <th>水</th>
                <th>木</th>
                <th>金</th>
                <th>土</th>
            </tr>
            </thead>
            <tbody>
            <td v-for="date in dates">
                {{date.day}}
            </td>
            </tbody>
        </table>
    </div>

</template>


<script>
  window.onload = function(){

    export default{
      data: {
        year: '',
        month: '',
        weekList: ['日', '月', '火', '水', '木', '金', '土'],
        dates: [],
      },
      created: function() {
        var now        = new Date();
        var this_year  = now.getFullYear();
        var this_month = now.getMonth() + 1;
        var start_date = new Date(this_year, this_month -1, 1);
        var end_date   = new Date(this_year, this_month, 0);
        var start_week = start_date.getDay();
        var dates      = Array.from(new Array(end_date.getDate())).map((v,i)=> i + 1)

        this.year  = this_year;
        this.month = this_month;
        for ( var i = 0; i < dates.length; i++ ) {
          var getDay = new Date(this.year, this.month -1, dates[i]).getDay();
          this.dates.push({week: getDay, day: dates[i]});
        };
        for ( var i = 0; i < start_week; i++) {
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
          var end_date = new Date(this.year, this.month, 0).getDate();
          this.dates = Array.from(new Array(end_date)).map((v,i)=> i + 1);
        }
      }
    }

  };
</script>
