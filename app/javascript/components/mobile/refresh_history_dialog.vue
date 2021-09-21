<template>
  <div>
    <a-modal
      title="更新历史"
      :visible="refresh_history_dialog_visible"
      :setting_id="setting_id"
      @ok="close"
      @cancel="close"
      :footer="null"
    >
      <div class="history-content">
        <a-timeline v-for="history in histories" :key="history.id">
          <a-timeline-item :color="select_timeline_status(history.status)">
            {{history.created_at_local_time}}
            &nbsp;
            <span
              v-if="history.new_feeds_count != null"
            >共更新 {{history.new_feeds_count}} 条 RSS</span>
          </a-timeline-item>
        </a-timeline>

        <a-spin :spinning="spinning" tip="Loading...">
          <div class="spin-content">
            <a-button type="link" v-on:click="show_more(setting_id)">
              <i class="fa fa-caret-down"></i>Load More
            </a-button>
          </div>
        </a-spin>
      </div>
    </a-modal>
  </div>
</template>

<script>
export default {
  props: [
    "refresh_history_dialog_visible",
    "setting_id",
    "type",
  ],
  data: function() {
    return {
      histories: [],
      page: 0,
      spinning: false
    };
  },
  watch: {
    refresh_history_dialog_visible: function(new_visible, old_visible) {
      if (new_visible) {
        this.histories = [];
        this.page = 1;
      }
    },
    page: function(new_page, old_page) {
      if (new_page == 0) {
        return;
      }

      var that = this;
      that.spinning = true;

      axios
        .get("/histories", {
          headers: {
            Accept: "application/json"
          },
          params: {
            setting_id: this.setting_id,
            page: this.page,
            type: this.type
          }
        })
        .then(function(reason) {
          that.spinning = false;
          that.append_histories(reason.data);
          if (reason.data.length == 0) {
            that.$message.info("暂无更多历史");
          }
        })
        .catch(function(reason) {
          that.spinning = false;
          that.$message.error(reason.toString());
        });
    }
  },
  methods: {
    close: function() {
      this.$emit("close");
      // 关闭时设为0是为了显示时可以设为1,可以触发page更新监听器
      this.page = 0;
    },
    append_histories: function(data) {
      var that = this;

      data.forEach(function(obj, index) {
        that.histories.push(obj);
      });
    },
    show_more: function() {
      this.page += 1;
    },
    select_timeline_status: function(status) {
      var color = null;
      switch (status) {
        case ("enqueue", "enqueued"):
          color = "gray";
          break;
        case "performing":
          color = "yellow";
          break;
        case "fail":
          color = "red";
          break;
        case "success":
          color = "green";
          break;
        default:
          break;
      }
      return color;
    }
  }
};
</script>

<style scoped></style>
