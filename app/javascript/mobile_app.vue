<template>
  <div id="app">
    <a-row>
      <a-col :md="4"></a-col>

      <a-col :sm="24" :md="16">
        <!--二级导航-->
        <a-tabs id="nav-tab" default-active-key="2">
          <a-tab-pane key="1">
            <span slot="tab">
              <i class="fa fa-newspaper-o"></i>&nbsp;最新动态
            </span>
            <a-empty>
              <a-button type="primary">去订阅</a-button>
            </a-empty>
            <!--        <new-feeds v-if="current[0] == 'new_feeds'"></new-feeds>-->
          </a-tab-pane>

          <a-tab-pane key="2">
            <span slot="tab">
              <i class="fa fa-rss"></i>&nbsp;RSS
              <a-tag color="#f50">{{ unread_count }}</a-tag>
            </span>

            <rss-list
              :user_id="user_id"
              :unread_count_rss_feeds_path="unread_count_rss_feeds_path"
              :rss_list_json="rss_list_json"
            ></rss-list>
          </a-tab-pane>

          <a-tab-pane key="3">
            <span slot="tab">
              <i class="fa fa-shopping-cart"></i>&nbsp;店铺监控
            </span>
            <goods-list></goods-list>
          </a-tab-pane>

          <a-button type="primary" slot="tabBarExtraContent" @click="show_add_dialog">
            <i class="fa fa-plus"></i>&nbsp;添加监控/订阅
          </a-button>
        </a-tabs>
        <add-dialog
          v-bind:dialog_visible="dialog_visible"
          v-on:close-dialog="dialog_visible = false"
        ></add-dialog>
      </a-col>

      <a-col :md="4"></a-col>
    </a-row>

    <a-back-top visibilityHeight="100px" />
  </div>
</template>

<script>
import RssList from "./components/mobile/rss_list.vue";
import GoodsList from "components/mobile/goods_list.vue";
import AddDialog from "components/mobile/add_dialog.vue";

export default {
  data: function() {
    return {
      dialog_visible: false,
      unread_count: 0,
      user_id: window.user_id,
      unread_count_rss_feeds_path: window.unread_count_rss_feeds_path,
      rss_list_json: window.rss_list_json,
      goods_data: window.goods_data
    };
  },
  methods: {
    show_add_dialog: function() {
      // 需要先置为 false，再设置为 true 才能再次显示添加的对话框
      this.dialog_visible = false;
      this.dialog_visible = true;
    }
  },
  mounted: function() {
    window.addEventListener("scroll", this.handleScroll);
  },
  components: {
    "rss-list": RssList,
    "goods-list": GoodsList,
    "add-dialog": AddDialog
  }
};
</script>

<style scoped></style>
