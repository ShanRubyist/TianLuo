<template>
  <a-drawer placement="right" :closable="true" :visible="visible" @close="onClose" width="90%">
    <!--        左侧商品列表-->
    <div class="good-list-group">
      <ul class="list-group">
        <template v-for="good in goods_data">
          <li
            class="list-group-item list-group-item-card"
            data-good-id="good.id"
            v-bind:class="{active: (current_good == good)}"
            v-on:click="change_good(good)"
          >
            <div>
              <div class="img-box">
                <img v-bind:src="good.goods_images[0]" />
              </div>
              <div class="description">
                <div>{{good.name}}</div>
                <div>{{good.spu_id}}</div>
              </div>
            </div>
          </li>
        </template>
      </ul>
    </div>

    <!--   右侧商品详情信息-->
    <div class="good-detail">
      <!--   商品基本信息-->
      <div class="good-detail-info">
        <shop-info :current_good="current_good"></shop-info>
      </div>

      <!--   商品扩展信息-->
      <div class="good-detail-extro">
        <a-spin :spinning="spinning" tip="Loading...">
          <div class="spin-content">
            <a-tabs default-active-key="1" size="small" @change="change_good_detail_tab">
              <a-tab-pane key="1" tab="标题变动">
                <title-change :name_list="name_list"></title-change>
              </a-tab-pane>

              <a-tab-pane key="2" tab="标语变动">
                <ad-change></ad-change>
              </a-tab-pane>

              <a-tab-pane key="3" tab="价格变动">
                <price-change></price-change>
              </a-tab-pane>

              <a-tab-pane key="4" tab="促销变动">
                <coupons-change :coupon_list="coupon_list"></coupons-change>
              </a-tab-pane>

              <a-tab-pane key="5" tab="评论数变动">
                <comments-num-change></comments-num-change>
              </a-tab-pane>
            </a-tabs>
          </div>
        </a-spin>
      </div>
    </div>
  </a-drawer>
</template>

<script>
import ShopInfo from "./shop_info.vue";
import AdChange from "./ad_change.vue";
import TitleChange from "./title_change.vue";
import PriceChange from "./price_change.vue";
import CouponsChange from "./coupons_change.vue";
import CommentsNumChange from "./comments_num_change.vue";

export default {
  props: ["visible", "goods_data", "current_good"],
  data: function() {
    return {
      coupon_list: null,
      price_list: null,
      comment_list: null,
      name_list: null,
      ad_list: null,
      spinning: false
    };
  },
  watch: {
    current_good: function() {
      this.refresh_tabs();
    }
  },
  updated: function() {
    // 会造成无限循环更新
    // this.refresh_tabs()
  },
  methods: {
    onClose: function() {
      this.$emit("close-drawer");
    },
    refresh_comments_tab: function() {
      var that = this;
      that.spinning = true;

      axios
        .get(window.location.href + "goods/comments", {
          headers: {
            Accept: "application/json"
          },
          params: {
            good_id: this.current_good.spu_id
          }
        })
        .then(function(reason) {
          that.comment_list = reason.data;

          // 基于准备好的dom，初始化echarts实例
          var myChart = echarts.init(document.getElementById("comment_graph"));

          // 指定图表的配置项和数据
          let option = {
            title: {
              text: "评价数走势图"
            },
            tooltip: {
              trigger: "axis"
            },
            grid: {
              left: "3%",
              right: "3%",
              bottom: "3%",
              containLabel: true
            },
            toolbox: {
              feature: {
                saveAsImage: {}
              }
            },
            xAxis: {
              type: "category",
              boundaryGap: false,
              data: that.comment_list.time
            },
            yAxis: {
              type: "value"
            },
            series: [
              {
                type: "line",
                data: that.comment_list.data
              }
            ]
          };

          // 使用刚指定的配置项和数据显示图表。
          myChart.setOption(option);
          that.spinning = false;
        })
        .catch(function(reason) {
          that.spinning = false;
        });
    },
    refresh_graph_tab: function() {
      var that = this;
      that.spinning = true;

      axios
        .get(window.location.href + "goods/prices", {
          headers: {
            Accept: "application/json"
          },
          params: {
            good_id: this.current_good.spu_id
          }
        })
        .then(function(reason) {
          that.price_list = reason.data;

          // 基于准备好的dom，初始化echarts实例
          var myChart = echarts.init(document.getElementById("price_graph"));

          // 指定图表的配置项和数据
          let option = {
            title: {
              text: "价格走势图"
            },
            tooltip: {
              trigger: "axis"
            },
            legend: {
              type: "scroll",
              top: 30,
              data: that.price_list.legend
            },
            grid: {
              left: "3%",
              right: "3%",
              top: 80,
              bottom: "3%",
              containLabel: true
            },
            toolbox: {
              feature: {
                saveAsImage: {}
              }
            },
            xAxis: {
              type: "category",
              boundaryGap: false,
              data: that.price_list.time
            },
            yAxis: {
              type: "value"
            },
            series: []
          };

          that.price_list.data.forEach(function(item) {
            option["series"].push({
              name: item.spec,
              type: "line",
              data: item.prices
            });
          });

          // 使用刚指定的配置项和数据显示图表。
          myChart.setOption(option);
          that.spinning = false;
        })
        .catch(function(reason) {
          that.spinning = false;
        });
    },
    refresh_coupons_tab: function() {
      var that = this;
      that.spinning = true;

      axios
        .get(window.location.href + "goods/coupons", {
          headers: {
            Accept: "application/json"
          },
          params: {
            good_id: this.current_good.spu_id
          }
        })
        .then(function(reason) {
          that.spinning = false;
          that.coupon_list = reason.data;
        })
        .catch(function(reason) {
          that.spinning = false;
        });
    },
    refresh_names_tab: function() {
      var that = this;
      that.spinning = true;

      axios
        .get(window.location.href + "goods/names", {
          headers: {
            Accept: "application/json"
          },
          params: {
            good_id: this.current_good.spu_id
          }
        })
        .then(function(reason) {
          that.spinning = false;
          that.name_list = reason.data;
        })
        .catch(function(reason) {
          that.spinning = false;
        });
    },
    refresh_ads_tab: function() {
      var that = this;
      that.spinning = true;

      axios
        .get(window.location.href + "goods/ads", {
          headers: {
            Accept: "application/json"
          },
          params: {
            good_id: this.current_good.spu_id
          }
        })
        .then(function(reason) {
          that.spinning = false;
          that.ad_list = reason.data;
        })
        .catch(function(reason) {
          that.spinning = false;
        });
    },
    refresh_tabs: function() {
      this.refresh_coupons_tab();
      this.refresh_comments_tab();
      this.refresh_graph_tab();
      this.refresh_names_tab();
      this.refresh_ads_tab();
    },
    change_good_detail_tab: function(key) {
      var that = this;
      if (key == 1) {
        that.refresh_names_tab();
      } else if (key == 2) {
        that.refresh_ads_tab();
      } else if (key == 3) {
        that.refresh_graph_tab();
      } else if (key == 4) {
        that.refresh_coupons_tab();
      } else if (key == 5) {
        that.refresh_comments_tab();
      }
    },
    change_good: function(good) {
      this.$emit("change-good", good);
    }
  },
  components: {
    "shop-info": ShopInfo,
    "ad-change": AdChange,
    "title-change": TitleChange,
    "coupons-change": CouponsChange,
    'comments-num-change': CommentsNumChange,
    "price-change": PriceChange
  }
};
</script>

<style scoped></style>
