<template>
  <div>
    <table class="table table-borderless table-responsive">
      <!--        表格头部-->
      <thead>
        <tr class="table-secondary">
          <th scope="col">商品信息(图片、编码）</th>
          <th scope="col">销量</th>
          <th scope="col">总评论数</th>
          <th scope="col">优惠卷</th>
          <th scope="col">服务名称</th>
          <th scope="col">
            操作
            <a-button type="link" v-on:click="toggle_show_more">展开</a-button>
          </th>
        </tr>
      </thead>

      <!--        表格内容-->
      <tbody>
        <template v-for="good in goods_data">
          <!--            第一行显示店铺信息-->
          <tr class="table-success" data-good-id="good.id">
            <td colspan="6">
              <a v-bind:href="good.shop_url" target="_blank">
                {{good.shop_name}}({{good.spu_id}})
                <a-tag color="#87d068">{{good.platform}}</a-tag>
              </a>
              <span>&nbsp;</span>
              <span>商品数量:{{good.goods_num}}</span>
              <span>&nbsp;</span>
              <span>销售量: {{good.shop_sales_num}}</span>
              <span>&nbsp;</span>
              <span>物流评分: {{good.logistics_score}}</span>

              <span>&nbsp;</span>
              <span>描述评分: {{good.desc_score}}</span>

              <span>&nbsp;</span>
              <span>服务评分: {{good.service_score}}</span>

              <span>&nbsp;</span>
              <span>最近更新状态:</span>
              <a-tooltip>
                <template slot="title">{{good.detail}}</template>
                <a-tag v-bind:color="select_tag_color(good.status)">{{good.status}}</a-tag>
              </a-tooltip>
            </td>
          </tr>

          <!--            第二行显示商品信息-->
          <tr>
            <th scope="row">{{good.name}}({{good.spu_id}})</th>
            <td>{{good.sales_num}}</td>
            <td>{{good.comments_total_num}}</td>
            <td>
              <template v-for="coupon in good.coupons">
                <a-tag color="#f50">{{coupon}}</a-tag>
              </template>
            </td>

            <td>
              <template v-for="service in good.mall_services">
                <a-tag color="#87d068">{{service}}</a-tag>
              </template>
            </td>

            <td>
              <a-button type="primary" v-on:click="showDetail(good)">查看详情</a-button>

              <a-button v-on:click="start_job('WebSpiderWorkJob', good.setting_id)">
                <i class="fa fa-refresh"></i>立即更新
              </a-button>

              <a-button v-on:click="delete_job(good.jid)">
                <i class="fa fa-stop"></i>停止运行
              </a-button>

              <a-button v-on:click="show_history_dialog(good.setting_id)">
                <i class="fa fa-sticky-note-o"></i>更新日志
              </a-button>

              <a-button>
                <i class="fa fa-edit"></i>编辑
              </a-button>

              <a-button type="danger" v-on:click="delete_setting(good.setting_id)">
                <i class="fa fa-trash-o"></i>删除
              </a-button>
            </td>
          </tr>

          <!--            第三行默认隐藏，显示评论和sku信息-->
          <tr class="table-warning">
            <td colspan="6" v-if="show_more">
              <a-tabs type="card">
                <a-tab-pane key="1" tab="SKU">
                  <table class="table table-sm">
                    <thead>
                      <tr>
                        <th scope="col">规格名称</th>
                        <th scope="col">平台SKU编码</th>
                        <th scope="col">正常价</th>
                        <th scope="col">团购价</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-for="sku in good.skus">
                        <th scope="row">{{sku.spec}}</th>
                        <td>{{sku.skuid}}</td>
                        <td>{{sku.normal_price}}</td>
                        <td>{{sku.group_price}}</td>
                      </tr>
                    </tbody>
                  </table>
                </a-tab-pane>
                <a-tab-pane key="2" tab="评论">
                  <a-list size="small" bordered :data-source="good.goods_comments">
                    <a-list-item slot="renderItem" slot-scope="item, index">
                      {{item[1]}}
                      <br />
                      <small>{{item[0]}}-{{item[2]}}</small>
                    </a-list-item>
                  </a-list>
                </a-tab-pane>
              </a-tabs>
            </td>
          </tr>
        </template>
      </tbody>
    </table>

    <good-detail
      v-bind:visible="visible"
      v-bind:goods_data="goods_data"
      v-bind:current_good="current_good"
      v-on:close-drawer="visible = false"
      v-on:change-good="current_good = $event"
    ></good-detail>

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
import GoodDetail from "./good_detail.vue";

export default {
  props: ["user_id", "goods_data"],
  data: function() {
    return {
      visible: false,
      show_more: false,
      current_good: goods_data.first,
      refresh_history_dialog_visible: false,
      setting_id: null,
      type: null
    };
  },
  methods: {
    toggle_show_more: function() {
      this.show_more = !this.show_more;
    },
    showDetail: function(good) {
      this.visible = true;
      this.current_good = good;
    },
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
      this.type = 1;
    },
    delete_setting: function(setting_id) {
      var that = this;

      this.$confirm({
        title: "Confirm",
        content: "Do you want to delete this item?",
        onOk() {
          axios
            .delete("/web_spider_settings/" + setting_id, {
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
    "refresh-history-dialog": RefreshHistoryDialog,
    "good-detail": GoodDetail
  }
};
</script>

<style scoped></style>
