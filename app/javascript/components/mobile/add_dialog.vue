<template>
  <a-modal v-model="visible" title="添加订阅/监控" centered width="60%" on-ok="handleOk">
    <template slot="footer" v-if="new_form_data.step == 0">
      <a-button key="cancel" @click="handleCancel">取消</a-button>
    </template>

    <template slot="footer" v-else-if="new_form_data.step == 1">
      <a-button key="back" @click="function () { new_form_data.step -= 1}">上一步</a-button>
      <a-button key="submit" type="primary" :loading="dialog_loading" @click="handleOk">确定</a-button>
    </template>

    <template>
      <a-steps :current="new_form_data.step" size="small">
        <a-step>
          <template slot="title">选择订阅/监控</template>
        </a-step>

        <a-step>
          <template slot="title">填写信息</template>
        </a-step>

        <a-step>
          <template slot="title">保存</template>
        </a-step>
      </a-steps>

      <template v-if="new_form_data.step == 0">
        <ul class="add-dialog">
          <li
            class="add-dialog-type-card"
            v-bind:class="{ active: (new_form_data.type == 1) }"
            v-on:click="next_step(); new_form_data.type =1"
          >添加RSS订阅</li>

          <li
            class="add-dialog-type-card"
            v-bind:class="{ active: (new_form_data.type == 2) }"
            v-on:click="next_step(); new_form_data.type =2"
          >添加监控店铺</li>
        </ul>
      </template>

      <template v-else-if="new_form_data.step == 1">
        <template v-if="new_form_data.type == 1">
          <form id="rss_form">
            <div class="form-group">
              <label>URL</label>
              <input
                class="form-control"
                id="rss_url"
                placeholder="url"
                v-model="new_form_data.url"
                required
              />
            </div>
            <div class="form-group">
              <label>Port</label>
              <input
                class="form-control"
                id="rss_port"
                placeholder="port"
                v-model="new_form_data.port"
              />
            </div>
            <div class="form-group">
              <label>Retry Limit</label>
              <input
                class="form-control"
                id="rss_retry_limit"
                placeholder="retry limit"
                v-model="new_form_data.retry_limit"
              />
            </div>

            <div class="form-group">
              <label>Proxy</label>
              <input
                class="form-control"
                id="rss_proxy"
                placeholder="proxy"
                v-model="new_form_data.proxy"
              />
            </div>
            <div class="form-group">
              <label>Status</label>
              <a-switch v-model:default-checked="new_form_data.status"></a-switch>
            </div>
          </form>
        </template>

        <template v-if="new_form_data.type == 2">
          <form id="spy_shop_form">
            <div class="form-group">
              <label>URL</label>
              <input
                class="form-control"
                id="spy_shop_url"
                placeholder="url"
                v-model="new_form_data.url"
                required
              />
            </div>
            <div class="form-group">
              <label>Port</label>
              <input
                class="form-control"
                id="spy_shop_port"
                placeholder="port"
                v-model="new_form_data.port"
              />
            </div>
            <div class="form-group">
              <label>Retry Limit</label>
              <input
                class="form-control"
                id="spy_shop_retry_limit"
                placeholder="retry limit"
                v-model="new_form_data.retry_limit"
              />
            </div>
            <div class="form-group">
              <label>Proxy</label>
              <input
                class="form-control"
                id="spy_shop_proxy"
                placeholder="proxy"
                v-model="new_form_data.proxy"
              />
            </div>
            <div class="form-group">
              <label>Cookies</label>
              <textarea
                class="form-control"
                id="spy_shop_cookies"
                placeholder="cookies"
                v-model="new_form_data.cookies"
              ></textarea>
            </div>
            <div class="form-group">
              <label>Status</label>
              <a-switch v-model:default-checked="new_form_data.status"></a-switch>
            </div>
          </form>
        </template>
      </template>
    </template>
  </a-modal>
</template>

<script>
// dialog 组件
export default {
  props: ["dialog_visible"],
  data: function() {
    return {
      dialog_loading: false,
      new_form_data: {
        step: 0,
        type: 0,
        url: null,
        port: 80,
        retry_limit: null,
        proxy: null,
        status: true,
        cookies: ""
      }
    };
  },
  computed: {
    visible: {
      get: function() {
        return this.dialog_visible;
      },
      set: function(val) {
        this.$emit("close-dialog");
      }
    }
  },
  methods: {
    handleCancel: function() {
      this.visible = false;
      this.dialog_loading = false;
    },
    handleOk: function() {
      this.dialog_loading = true;

      var that = this;
      var url = "";
      var setting = {};
      if (this.new_form_data.type == 1) {
        url = "/probe_settings";
        setting = {
          authenticity_token: document
            .getElementsByName("csrf-token")[0]
            .getAttribute("content"),
          probe_setting: {
            user_id: user_id,
            url: that.new_form_data.url,
            port: that.new_form_data.port,
            retry_limit: that.new_form_data.retry_limit,
            proxy: that.new_form_data.proxy,
            cookies: that.new_form_data.cookies,
            status: that.new_form_data.status
          }
        };
      } else if (this.new_form_data.type == 2) {
        url = "/web_spider_settings";
        setting = {
          authenticity_token: document
            .getElementsByName("csrf-token")[0]
            .getAttribute("content"),
          web_spider_setting: {
            user_id: user_id,
            url: that.new_form_data.url,
            port: that.new_form_data.port,
            retry_limit: that.new_form_data.retry_limit,
            proxy: that.new_form_data.proxy,
            cookies: that.new_form_data.cookies,
            status: that.new_form_data.status
          }
        };
      }
      axios
        .post(url, setting, {
          headers: {
            Accept: "application/json"
          }
        })
        .then(function(reason) {
          that.$message.success(reason.data.message);
          that.dialog_loading = false;
          that.visible = false;

          that.clear_new_form_data();
        })
        .catch(function(reason) {
          that.$message.error(reason.toString());
          that.dialog_loading = false;
        });
    },
    clear_new_form_data: function() {
      this.new_form_data = {
        step: 0,
        type: 0,
        url: null,
        port: 80,
        retry_limit: null,
        proxy: null,
        status: true,
        cookies: ""
      };
    },
    next_step: function() {
      this.new_form_data.step += 1;
    }
  }
};
</script>

<style scoped></style>
