<template>
  <div id="app">
    <div class="app-wrapper">
      <!--    工具栏区域-->
      <sidebar id="sidebar"
               :full_screen="full_screen"
               :unread_count="unread_count"
               @rss_feed="rss_feed"
               @recommend="recommend"
               @favor="favor"
               @toggle_cat_wrapper="toggle_cat_wrapper"
      ></sidebar>

      <!--    订阅列表区域-->
      <cat-wrapper id="cat-wrapper"
                   :full_screen="full_screen"
                   :all_rss_list_json="all_rss_list_json"
                   :unread_count="unread_count"
                   :cat_wrapper_visible="cat_wrapper_visible"
                   :current_rss="current_rss"
                   @change_rss="change_rss"
      ></cat-wrapper>

      <!--Feed 列表区域-->
      <article-list id="article-list"
                    :full_screen="full_screen"
                    :article_list_loading="article_list_loading"
                    :rss_list_json="rss_list_json"
                    :rss_list_json1="rss_list_json1"
                    :current_rss="current_rss"
                    :current_article="current_article"
                    :current_page="current_page"
                    :total_num="total_num"
                    :latest_total_num="latest_total_num"
                    :latest_unread_count="latest_unread_count"
                    :total_unread_count="total_unread_count"
                    @change_article="change_article"
                    @next_page="next_page"
                    @refresh_list="change_rss"

      ></article-list>

      <!--    Feed 详情内容-->
      <article-detail id="article-detail"
        :full_screen="full_screen"
                      :article_list_loading="article_list_loading"
                      :current_article="current_article"
        :font_list="font_list"
        @full_screen_mode="full_screen_mode"
      >
      </article-detail>

      <div class="fixed-audio__wrapper" style="display: none">
        <!---->
        <div class="fixed-audio">
          <div class="fixed-audio__top">
            <div class="fixed-audio__control-toggle">
              <i class="iconfont icon-play"></i>
            </div>
            <!---->
            <div class="fixed-audio__info">
              <div class="fixed-audio__title text--ellipsis">--</div>
              <div class="fixed-audio__time">00:00 / 00:00</div>
            </div>
            <div class="fixed-audio__control-collapse">
              <i class="iconfont icon-right"></i>
            </div>
          </div>
          <div
            role="slider"
            aria-valuemin="0"
            aria-valuemax="0"
            aria-orientation="horizontal"
            class="el-slider fixed-audio__track"
            aria-valuetext="0"
            aria-label="slider between 0 and 0"
          >
            <!---->
            <div class="el-slider__runway">
              <div class="el-slider__bar" style="left: 0%"></div>
              <div tabindex="0" class="el-slider__button-wrapper">
                <div
                  class="el-slider__button el-tooltip"
                  aria-describedby="el-tooltip-7898"
                  tabindex="0"
                ></div>
              </div>
              <!---->
            </div>
          </div>
        </div>
        <div class="fixed-audio__side fixed-audio__control-close">
          <i class="iconfont icon-close-heavy"></i>
        </div>
        <audio
          id="player"
          preload="auto"
          controls="controls"
          style="display: none"
        >
          audio
        </audio>
      </div>

      <div>
        <div class="el-dialog__wrapper" style="display: none">
          <div
            class="el-dialog el-dialog--center"
            style="width: 500px; margin-top: 30vh"
          >
            <div class="el-dialog__header">
              <span class="el-dialog__title">源信息</span>
              <button
                type="button"
                aria-label="Close"
                class="el-dialog__headerbtn"
              >
                <i class="el-dialog__close el-icon el-icon-close"></i>
              </button>
            </div>
            <!---->
            <!---->
          </div>
        </div>
      </div>
    </div>

    <!--  Feed 详情内容下拉菜单-->
    <ul
      class="el-dropdown-menu el-popper"
      id="dropdown-menu-1877"
      style="transform-origin: center top; z-index: 2003; display: none"
    >
      <li tabindex="-1" class="el-dropdown-menu__item">设为已读(M)</li>
      <li tabindex="-1" class="el-dropdown-menu__item">进入该订阅源</li>
      <li tabindex="-1" class="el-dropdown-menu__item">查看源信息</li>
      <!---->
      <li
        tabindex="-1"
        class="el-dropdown-menu__item el-dropdown-menu__item--divided"
      >
        保存到印象笔记
      </li>
      <div x-arrow class="popper__arrow" style="left: 62.5px"></div>
    </ul>

    <div
      role="tooltip"
      id="el-popover-4023"
      aria-hidden="true"
      class="el-popover el-popper"
      tabindex="0"
      style="
        width: 324px;
        transform-origin: center top;
        z-index: 2005;
        display: none;
      "
    >
      <!---->
      <div class="el-select" style="width: 100%">
        <div class="el-select__tags" style="max-width: 266px">
          <!---->
          <span></span>
          <input
            type="text"
            autocomplete="off"
            debounce="0"
            class="el-select__input"
            style="width: 20px; max-width: 256px"
          />
        </div>
        <div class="el-input el-input--suffix">
          <!---->
          <input
            type="text"
            readonly="readonly"
            autocomplete="off"
            placeholder="创建或搜索标签，最多5个"
            class="el-input__inner"
            style="height: 40px"
          />
          <!---->
          <span class="el-input__suffix">
            <span class="el-input__suffix-inner">
              <i class="el-select__caret el-input__icon el-icon-arrow-up"></i>
              <!---->
            </span>
            <!---->
          </span>
          <!---->
        </div>
        <div
          class="el-select-dropdown el-popper is-multiple"
          style="display: none; min-width: 0px"
        >
          <div class="el-scrollbar" style>
            <div
              class="el-select-dropdown__wrap el-scrollbar__wrap"
              style="margin-bottom: -15px; margin-right: -15px"
            >
              <ul class="el-scrollbar__view el-select-dropdown__list">
                <!---->
                <li class="el-select-dropdown__item">
                  <span>Django</span>
                </li>
              </ul>
            </div>
            <div class="el-scrollbar__bar is-horizontal">
              <div
                class="el-scrollbar__thumb"
                style="transform: translateX(0%)"
              ></div>
            </div>
            <div class="el-scrollbar__bar is-vertical">
              <div
                class="el-scrollbar__thumb"
                style="transform: translateY(0%)"
              ></div>
            </div>
          </div>
          <!---->
        </div>
      </div>
      <div class="el-popover__footer">
        <button type="button" class="el-button el-button--text el-button--mini">
          <!---->
          <!---->
          <span>取 消</span>
        </button>
        <button
          type="button"
          class="el-button el-button--primary el-button--mini"
        >
          <!---->
          <!---->
          <span>确 定</span>
        </button>
      </div>
      <div x-arrow class="popper__arrow" style="left: 154.5px"></div>
    </div>
    <div
      role="tooltip"
      id="el-tooltip-6055"
      aria-hidden="true"
      class="el-tooltip__popper is-dark"
      style="transform-origin: center top; z-index: 2007; display: none"
    >
      2021-04-30 17:00:01
      <div x-arrow class="popper__arrow" style="left: 61.5px"></div>
    </div>
    <div
      role="tooltip"
      id="el-popover-250"
      aria-hidden="true"
      class="el-popover el-popper highlight-popover"
      tabindex="0"
      style="
        width: 150px;
        transform-origin: center top;
        z-index: 2009;
        display: none;
      "
    >
      <!---->
      <div class="flexbox--center">
        <i class="iconfont icon-forbid"></i>
        <span class="highlight-block yellow"></span>
        <span class="highlight-block red"></span>
        <span class="highlight-block green"></span>
      </div>
      <div x-arrow class="popper__arrow" style="left: 67.5px"></div>
    </div>
  </div>
</template>

<script>
import Sidebar from "components/web/sidebar.vue";
import CatWarpper from "components/web/cat_wrapper.vue";
import ArticleList from "components/web/article_list.vue";
import ArticleDetail from "components/web/article_detail.vue";

export default {
  data: function () {
    return {
      cat_wrapper_visible: true,
      rss_list_json1: rss_list_json1,
      rss_list_json: rss_list_json,
      all_rss_list_json: window.all_rss_list_json,
      current_article: window.rss_list_json[0],
      current_rss: null,
      qrcode: null,
      full_screen: false,
      font_list: window.font_list,
      article_list_loading: false,
      current_page: window.rss_list_json1.current_page,
      total_num: rss_list_json1.total_num_of_current_rss,
      latest_total_num: rss_list_json1.total_num_of_current_rss,
      unread_count: rss_list_json1.total_unread_count,
      latest_unread_count: rss_list_json1.total_unread_count_of_current_rss,
      total_unread_count: rss_list_json1.total_unread_count_of_current_rss
    };
  },
  methods: {
    change_article: function (article) {
      this.current_article = article;
    },
    rss_feed: function () {
      this.rss_list_json = window.rss_list_json;
      this.current_article = window.rss_list_json[0];
      this.cat_wrapper_visible = true
    },
    recommend: function (data) {
      this.rss_list_json = data;
      this.current_article = data[0];
      this.cat_wrapper_visible = false;
    },
    favor: function (data) {
      this.rss_list_json = data;
      this.current_article = data[0];
      this.cat_wrapper_visible = false;
    },
    toggle_cat_wrapper: function () {
      this.cat_wrapper_visible = !this.cat_wrapper_visible;
    },
    full_screen_mode: function () {
      this.full_screen = !this.full_screen;
    },
    change_rss: async function(rss) {
      this.current_rss = rss;
      var that = this;

      try {
        app.__vue__.article_list_loading = true;
        let promise = axios
            .get("/rss_feeds/", {
              headers: {
                Accept: "application/json"
              },
              params: {
                user_id: user_id,
                rss: rss
              }
            })

        let response = await promise;
        // console.log(response.data)

        let data = response.data.data;
        this.rss_list_json1 = data;
        this.rss_list_json = this.rss_list_json1.rss_feed_list;
        this.current_article = this.rss_list_json[0];
        this.current_rss = rss;
        this.article_list_loading = false;
        this.current_page = this.rss_list_json1.current_page;
        this.total_num = this.rss_list_json1.total_num_of_current_rss;
        this.latest_total_num = this.rss_list_json1.total_num_of_current_rss;

        this.total_unread_count = this.rss_list_json1.total_unread_count_of_current_rss;
        this.latest_unread_count = this.total_unread_count;
      } catch (error) {
        that.$message.error(error.toString());
      };
    },
    next_page: function (data) {
      // console.log(this.rss_list_json1)
      this.rss_list_json1 = data;
      this.rss_list_json = this.rss_list_json.concat(this.rss_list_json1.rss_feed_list);

      this.current_article = this.rss_list_json[0];
      // this.article_list_loading = false;
      this.current_page = this.rss_list_json1.current_page;

      this.total_num = this.rss_list_json1.total_num_of_current_rss;
      this.latest_total_num = this.rss_list_json1.total_num_of_current_rss;
      this.total_unread_count = this.rss_list_json1.total_unread_count_of_current_rss;
      this.latest_unread_count = this.total_unread_count;
    },
    refresh_rss_feed_list_info: async function () {
      var that = this;

      try {
        let promise = axios
            .get("/rss_feeds/briefly_info", {
              headers: {
                Accept: "application/json"
              },
              params: {
                rss: this.current_rss
              }
            })

        let response = await promise;
        // console.log(response.data)

        let data = response.data;

        this.latest_total_num = data.total_num_of_current_rss;
        this.latest_unread_count = data.total_unread_count_of_current_rss;
      } catch (error) {
        that.$message.error(error.toString());
      };
    },
    init_websocket: function () {
      let url;
      if(window.location.protocol == "https:") {
        url = "wss://" + window.location.host + "/cable"
      } else {
        url = "ws://" + window.location.host + "/cable"
      }
      let ws = new WebSocket(url)

      let that = this;

      ws.onopen = function () {
        console.log("connected");
        ws.send(JSON.stringify({
          "command": "subscribe", "identifier": '{"channel":"TlChannel","user_id":' + user_id + '}'
        }))
      };

      ws.onmessage = function (data) {
        let info = JSON.parse(data.data);

        if ((info['type'] == null) || (info['type'] == undefined)) {
          console.log("ws get message: " + info['message']['info']);

          if (info['message']['info']['type'] == 'tl_update_unread_count') {
            that.all_rss_list_json = info['message']['info']["rss_list"];
            // that.latest_total_num = info['message']['info']["total_num_of_current_rss"];
            that.unread_count = info['message']['info']["total_unread_count"];
            // that.latest_unread_count = info['message']['info']["total_unread_count_of_current_rss"];
            window.favicon.badge(that.unread_count);
            that.refresh_rss_feed_list_info();
          } else if (info['message']['info']['type'] == 'tl_update_status') {
            // that.rss_list_json = info['message']['info']["rss_feed_list"];
          }
        }
      };

      ws.onclose = function () {
        console.log("disconnected");
        that.reconnect_websocket();
      }
    },
    reconnect_websocket: function (){
      var that = this;
      console.log("websocker 重连");

      setTimeout(function () {
        that.init_websocket();
      }, 10 * 1000);
    }
  },
  mounted: function () {
    // 定时轮询未读的rss feed数量
    // setInterval(function () {
    //   axios
    //     .get(unread_count_rss_feeds_path, {
    //       headers: {
    //         Accept: "application/json",
    //       },
    //       params: {
    //         id: user_id,
    //       },
    //     })
    //     .then(function (reason) {
    //       // app._data.unread_count = reason.data.unread_count;
    //       // app.__vue__._data.unread_count = reason.data.unread_count;
    //       app.__vue__.unread_count = reason.data.unread_count;
    //       window.favicon.badge(reason.data.unread_count);
    //     })
    //     .catch(function (reason) {});
    // }, 5000);

    window.favicon.badge(this.latest_unread_count);
    this.init_websocket();

    // 新手教程
    if (!localStorage.getItem("has_show_tutor")) {
      introJs()
        .setOptions({
          steps: [
            {
              element: document.querySelector("#sidebar"),
              title: "工具栏",
              intro: "你可以点击切换，使用不同功能",
              position: "auto",
            },
            {
              element: document.querySelector("#cat-wrapper"),
              title: "RSS源",
              intro: "你可以查看到所有你订阅的RSS源",
              position: "bottom-right-aligned",
            },
            {
              element: document.querySelector("#article-list"),
              title: "RSS文章列表",
              intro: "按照时间顺序显示RSS文章列表",
              position: "right",
            },
            {
              element: document.querySelector("#article-detail"),
              title: "RSS文章内容",
              intro: "可以阅读RSS文章、切换字体、收藏等",
              position: "left",
            },
          ],
          showStepNumbers: true,
          prevLabel: '上一步',
          nextLabel: '下一步',
          doneLabel: '完成',
          // skipLabel: '跳过',
          keyboardNavigation: true,
          exitOnEsc: true,
          exitOnOverlayClick: false
        })
        .start();
      
      localStorage.setItem('has_show_tutor', true)
    }
  },
  components: {
    sidebar: Sidebar,
    "cat-wrapper": CatWarpper,
    "article-list": ArticleList,
    "article-detail": ArticleDetail,
  },
};
</script>

<style scoped></style>
