<template>
<div>
  <add-dialog v-bind:dialog_visible="dialog_visible" v-on:close-dialog="dialog_visible = false">

  </add-dialog>

  <aside v-show="!full_screen" class="sidebar collapsed">
    <div class="drag-area"></div>

    <div>
      <a-button
        class="el-button sub-btn circle el-button--primary"
        @click="show_add_dialog"
      >
        <span>
          <i class="iconfont icon-add"></i>
        </span>
      </a-button>
    </div>

    <div class="nav-list">
      <div class="nav-item"
           :class="{active: is_rss_feed_active}"
           :title="this.unread_count + '篇未读文章'"
           @click="rss_feed">
        <i class="iconfont icon-eye"></i>
      </div>
      <div class="nav-item"
           :class="{active: is_recommend_active}"
           title="猜你感兴趣"
           @click="recommend">
        <i class="iconfont icon-inbox"></i>
      </div>
      <div class="nav-item"
           :class="{active: is_favor_active}"
           title="我的收藏"
           @click="favor">
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
  props: ['full_screen', 'unread_count'],
  data: function () {
    return {
      dialog_visible: false,
      is_rss_feed_active: true,
      is_recommend_active: false,
      is_favor_active: false
    }
  },
  methods: {
    recommend: function(e) {
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
          // e.target.parentElement.classList.add("active")
          // [that.is_rss_feed_active, that.is_recommend_active, that.is_favor_active] = [false, true, false]
          that.is_rss_feed_active = false
          that.is_recommend_active = true
          that.is_favor_active = false
          console.log(that.is_favor_active)
          console.log(that.is_recommend_active)
          console.log(that.is_rss_feed_active)
        })
        .catch(function(reason) {
          that.$message.error(reason.toString());
        });
    },
    favor: function(e) {
      var that = this;
      axios
          .get("/rss_feeds/favor", {
            headers: {
              Accept: "application/json"
            },
            params: {
              user_id: user_id
            }
          })
          .then(function(reason) {
            that.$emit('favor', reason.data)
            // [that.is_rss_feed_active, that.is_recommend_active, that.is_favor_active] = [false, false, true]
            that.is_rss_feed_active = false
            that.is_recommend_active = false
            that.is_favor_active = true
            console.log(that.is_favor_active)
            console.log(that.is_recommend_active)
            console.log(that.is_rss_feed_active)
          })
          .catch(function(reason) {
            that.$message.error(reason.toString());
          });
    },
    rss_feed: function (e) {
      this.$emit('rss_feed')
      // [this.is_rss_feed_active, this.is_recommend_active, this.is_favor_active] = [true, false, false]
      this.is_rss_feed_active = true
      this.is_recommend_active = false
      this.is_favor_active = false
      console.log(this.is_favor_active)
      console.log(this.is_recommend_active)
      console.log(this.is_rss_feed_active)
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
