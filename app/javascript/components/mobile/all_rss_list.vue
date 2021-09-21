<template>
  <div>
    <table class="table table-borderless table-responsive">
      <!--        表格头部-->
      <thead>
        <tr class="table-success">
          <th scope="col">RSS</th>
          <th scope="col">Latest Updated</th>
          <th scope="col">Status</th>
          <th scope="col">Operation</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="rss in all_rss_list">
          <td>
            <div>
              <a v-bind:href="rss.rss" target="_blank">{{rss.rss}}</a>
            </div>

            <div>Port: {{rss.port}}</div>
            <div v-show="rss.proxy">Proxy: {{rss.proxy}}</div>
            <div v-show="rss.retry_limit">Retry Limit: {{rss.retry_limit}}</div>
          </td>

          <td>
            <div>{{rss.latest_updated}}</div>
          </td>

          <td>
            <a-tooltip>
              <template slot="title">{{rss.detail}}</template>
              <a-tag v-bind:color="select_tag_color(rss.status)">{{rss.status}}</a-tag>
            </a-tooltip>
          </td>
          <td>
            <a-button>
              <i class="fa fa-rss"></i>查看Feeds
            </a-button>
            <a-button v-on:click="start_job('RssWorkJob', rss.probe_settings_id)">
              <i class="fa fa-refresh"></i>立即更新
            </a-button>

            <a-button v-on:click="delete_job(rss.jid)">
              <i class="fa fa-stop"></i>停止运行
            </a-button>

            <a-button v-on:click="show_history_dialog(rss.probe_settings_id)">
              <i class="fa fa-sticky-note-o"></i>更新日志
            </a-button>
            <a-button v-on:click="edit_setting(rss.probe_settings_id)">
              <i class="fa fa-edit"></i>编辑
            </a-button>
            <a-button type="danger" v-on:click="delete_setting(rss.probe_settings_id)">
              <i class="fa fa-trash-o"></i>删除
            </a-button>
          </td>
        </tr>
      </tbody>
    </table>

    <refresh-history-dialog
      v-bind:refresh_history_dialog_visible="refresh_history_dialog_visible"
      v-bind:setting_id="setting_id"
      v-bind:type="type"
      v-on:close="refresh_history_dialog_visible = false"
    ></refresh-history-dialog>
  </div>
</template>

<script>
import RefreshHistoryDialog from "./refresh_history_dialog.vue";

export default {
  props: ['all_rss_list'],
  data: function() {
    return {
      refresh_history_dialog_visible: false,
      setting_id: null,
      type: null
    };
  },
  created: setInterval(function() {
    axios
      .get("/running_jobs_count", {
        headers: {
          Accept: "application/json"
        }
      })
      .then(function(reason) {
        app._data.rss_running_missions = reason.data.running_rss_jobs_count;
        // app._data.good_running_missions = reason.data.running_goods_jobs_count
      })
      .catch(function(reason) {});
  }, 5000),
  methods: {
    select_tag_color: function(content) {
      var tag_color = null;
      switch (content) {
        case "success":
          tag_color = "green";
          break;
        case "fail":
          tag_color = "red";
          break;
        case "performing":
          tag_color = "yellow";
          break;
        case "enqueued":
          tag_color = "";
          break;
        case "enqueue":
          tag_color = "gray";
          break;
        default:
          break;
      }
      return tag_color;
    },
    start_job: function(type, id) {
      var that = this;

      axios
        .post(
          "/start_job",
          {
            type: type,
            id: id,
            authenticity_token: document
              .getElementsByName("csrf-token")[0]
              .getAttribute("content")
          },
          {
            headers: {
              Accept: "application/json"
            }
          }
        )
        .then(function(reason) {
          that.$message.success(reason.data.message);
        })
        .catch(function(reason) {
          that.$message.error(reason.toString());
        });
    },
    delete_job: function(jid) {
      var that = this;

      axios
        .delete("/delete_job", {
          headers: {
            Accept: "application/json"
          },
          params: {
            jid: jid,
            authenticity_token: document
              .getElementsByName("csrf-token")[0]
              .getAttribute("content")
          }
        })
        .then(function(reason) {
          that.$message.success(reason.data.message);
        })
        .catch(function(reason) {
          that.$message.error(reason.toString());
        });
    },
    show_history_dialog: function(setting_id) {
      this.refresh_history_dialog_visible = true;
      this.setting_id = setting_id;
      this.type = 0;
    },
    edit_setting: function(setting_id) {},
    delete_setting: function(setting_id) {
      var that = this;

      this.$confirm({
        title: "Confirm",
        content: "Do you want to delete this item?",
        onOk() {
          axios
            .delete("/probe_settings/" + setting_id, {
              headers: {
                Accept: "application/json"
              },
              params: {
                authenticity_token: document
                  .getElementsByName("csrf-token")[0]
                  .getAttribute("content")
              }
            })
            .then(function(reason) {
              that.$message.success(reason.data.message);
            })
            .catch(function(reason) {
              that.$message.error(reason.toString());
            });
        },
        onCancel() {}
      });
    }
  },
  components: {
    'refresh-history-dialog': RefreshHistoryDialog
  }
};
</script>

<style scoped></style>
