<template>
<div>
  <add-dialog v-bind:dialog_visible="dialog_visible" v-on:close-dialog="dialog_visible = false">

  </add-dialog>

  <aside v-show="!full_screen" class="sidebar collapsed">
    <div class="drag-area"></div>

    <div>
      <a-button
        type="button"
        class="el-button sub-btn circle el-button--primary"
        @click="show_add_dialog"
      >
        <span>
          <i class="iconfont icon-add"></i>
        </span>
      </a-button>
    </div>

    <div class="nav-list">
      <div class="nav-item" :class="{active: true}" title="5677 篇未读文章">
        <i class="iconfont icon-eye"></i>
      </div>
      <div class="nav-item" title="猜你感兴趣" @click="recommend">
        <i class="iconfont icon-rss"></i>
      </div>
      <div class="nav-item" title="我的收藏">
        <i class="iconfont icon-heart"></i>
      </div>
    <add-dialog v-bind:dialog_visible="dialog_visible" v-on:close-dialog="dialog_visible = false"></add-dialog>
    <add-dialog v-bind:dialog_visible="dialog_visible" v-on:close-dialog="dialog_visible = false"></add-dialog>
      <div class="nav-item" title="标签标记">
        <i class="iconfont icon-tag"></i>
      </div>
      <div class="nav-item" @click="toggle_cat_wrapper">
        <i class="iconfont icon-unorderedlist"></i>
      </div>
    </div>
  </aside>
</div>
</template>

<script>
import AddDialog from "components/mobile/add_dialog.vue";

export default {
  props: ['full_screen'],
  data: function () {
    return {
      dialog_visible: false,
    }
  },
  methods: {
    recommend: function() {
      var that = this;
      axios
        .get("/rss_feeds/recommend", {
          headers: {
            Accept: "application/json"
          },
          params: {
            user_id: user_id
          }
        })
        .then(function(reason) {
          that.$emit('recommend', reason.data)
        })
        .catch(function(reason) {
          that.$message.error(reason.toString());
        });
    },
    show_add_dialog: function() {
      // 需要先置为 false，再设置为 true 才能再次显示添加的对话框
      this.dialog_visible = false;
      this.dialog_visible = true;
    },
    toggle_cat_wrapper: function() {
      this.$emit('toggle_cat_wrapper')
    },
  },
  components: {
    "add-dialog": AddDialog
  }
};
</script>

<style scoped></style>
