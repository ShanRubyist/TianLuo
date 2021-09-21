<template>
  <div id="app">
    <a-row>
      <a-col :md="4"></a-col>

      <a-col :sm="24" :md="16">
        <div class="banner" style="font-size: 16px">
          <a href="/">返回首页</a>
        </div>

        <a-tabs type="card">
          <a-tab-pane key="1">
            <span slot="tab">
              RSS订阅列表
              <a-tag color="#FADB14">{{rss_running_missions}}</a-tag>
            </span>
            <all-rss-list
            :all_rss_list="all_rss_list">
            </all-rss-list>
          </a-tab-pane>
          <!--        <a-tab-pane key="2">-->
          <!--          <span slot="tab">-->
          <!--            监控店铺列表-->
          <!--            <a-tag color="#FADB14">{{good_running_missions}}</a-tag>-->
          <!--          </span>-->
          <!--          <all-good-list></all-good-list>-->
          <!--        </a-tab-pane>-->

          <a-button type="primary" slot="tabBarExtraContent" @click="show_add_dialog">
            <i class="fa fa-plus"></i>&nbsp;添加监控/订阅
          </a-button>
        </a-tabs>
      </a-col>

      <add-dialog v-bind:dialog_visible="dialog_visible" v-on:close-dialog="dialog_visible = false"></add-dialog>
    </a-row>
  </div>
</template>

<script>
import AddDialog from "components/mobile/add_dialog.vue";
import AllRssList from "components/mobile/all_rss_list.vue";

export default {
  data: function() {
    return {
      dialog_visible: false,
      rss_running_missions: running_rss_jobs_count,
      all_rss_list: window.all_rss_list,
    };
  },
  methods: {
    show_add_dialog: function() {
      // 需要先置为 false，再设置为 true 才能再次显示添加的对话框
      this.dialog_visible = false;
      this.dialog_visible = true;
    }
  },
  components: {
    "all-rss-list": AllRssList,
    "add-dialog": AddDialog
  }
};
</script>

<style scoped></style>
