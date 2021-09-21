<template>
  <div class="article-detail">
    <div style>
      <div>
        <div class="article-toolbar__drag-area"></div>
        <div
          class="flexbox article-toolbar"
          style="justify-content: space-between; align-items: center; flex-wrap: nowrap;"
        >
          <div
            class="flexbox article-account__box"
            style="justify-content: flex-start; align-items: center; flex-wrap: nowrap;"
          >
            <i class="iconfont icon-left article-back"></i>
            <span>
              <div
                role="tooltip"
                id="el-popover-6989"
                aria-hidden="true"
                class="el-popover el-popper account-popover"
                tabindex="0"
                style="width: 400px; display: none;"
              >
                <!---->
                <div
                  class="flexbox"
                  style="justify-content: space-between; align-items: flex-start; flex-wrap: nowrap;"
                >
                  <!---->
                  <div class="account-popover__main" style="margin-left: 0px;">
                    <div class="account-popover__top">
                      <div>
                        <span class="account-popover__title">{{current_article.rss}}</span>
                        <!---->
                      </div>
                      <div class="account-popover__desc">{{current_article.rss_description}}</div>
                      <div class="info-container">
                        <div class="info-item">
                          <span class="info-item__label">site url:</span>
                          <span class="info-item__value flexbox">
                            <a
                              :href="current_article.rss_link"
                              target="_blank"
                            >{{current_article.rss_link}}</a>
                            <a :href="current_article.rss_link" target="_blank">
                              {{current_article.rss_link}}
                              <i
                                class="iconfont icon-send"
                                style="padding-left: 10px;"
                              ></i>
                            </a>
                          </span>
                        </div>
                        <div class="info-item">
                          <span class="info-item__label">xml url:</span>
                          <div class="info-item__value flexbox">
                            <span class="text--ellipsis">{{current_article.rss_link}}</span>
                            <span class="copy">
                              <i class="iconfont icon-copy"></i>
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                    <!---->
                  </div>
                </div>
              </div>
              <img
                :src="current_article.icon"
                class="avatar el-popover__reference"
                aria-describedby="el-popover-6989"
                tabindex="0"
                alt
              />
            </span>
            <span style="display: none;"></span>
            <span style="display: none;"></span>
            <span style="display: none;"></span>
            <span style="display: none;"></span>
            <span class="article-account__title text--ellipsis">{{current_article.rss}}</span>
          </div>
          <div class="article-actions">
            <span>
              <i
                title="标记"
                class="iconfont icon-highlight el-popover__reference"
                aria-describedby="el-popover-250"
                tabindex="0"
              ></i>
            </span>
            <i title="收藏" class="iconfont icon-collection" @click="thumbs_up(current_article.id)"></i>
            <span>
              <i
                title="添加标签"
                class="iconfont icon-label el-popover__reference"
                aria-describedby="el-popover-4023"
                tabindex="0"
              ></i>
            </span>
            <a
              title="访问原始文章[V (visit)]"
              id="ori_link"
              :href="current_article.link"
              target="_blank"
              class="js-external-link article-link"
            >
              <i class="iconfont icon-send"></i>
            </a>

            <i
              @click="full_screen_mode"
              title="全屏阅读[F (fullscreen)]"
              class="iconfont icon-screenfull"
            ></i>

            <a-popover trigger="click" ref="pop">
              <a slot="content">
                <div ref="qrcode"></div>
              </a>
              <div style="display: none" ref="qrcode2"></div>

              <span @click="create_qr_code(current_article.link)">
                <i
                  title="手机端查看"
                  class="iconfont icon-qr el-popover__reference"
                  aria-describedby="el-popover-6140"
                  tabindex="0"
                ></i>
              </span>
            </a-popover>

            <div class="el-dropdown">
              <i
                class="iconfont icon-more el-dropdown-selfdefine"
                aria-haspopup="list"
                aria-controls="dropdown-menu-1877"
                role="button"
                tabindex="0"
              ></i>
            </div>
          </div>
        </div>
      </div>
      <div class="article-wrapper">
        <div id="article-content" class="article-content">
          <div style="padding-bottom: 20px">
            <a-tag v-for="tag in current_article.tags" closable @close="del_tag">{{tag}}</a-tag>
            <a-tag @click="add_tag">+</a-tag>
          </div>
          <h2 class="article-title">{{current_article.title}}</h2>
          <div class="article-meta">
            <span>
              <div
                role="tooltip"
                id="el-popover-4775"
                aria-hidden="true"
                class="el-popover el-popper"
                tabindex="0"
                style="display: none;"
              >
                <div>
                  <div class="account-popover__desc">全部文章数: --</div>
                  <div class="account-popover__desc">今日文章数: --</div>
                </div>
              </div>

              <span
                class="author el-popover__reference"
                aria-describedby="el-popover-4775"
                tabindex="0"
              >{{current_article.author}}</span>
            </span>
            <!---->
            <time
              datetime="Fri Apr 30 2021 17:00:01 GMT+0800 (中国标准时间)"
              class="el-tooltip item"
              aria-describedby="el-tooltip-6055"
              tabindex="0"
            >{{current_article.pub_date}}</time>

            <!---->
          </div>
          <!---->
          <div
            id="article-body"
            class="article-body locale-chinese"
            v-html="current_article.description"
          ></div>
        </div>
      </div>
      <div class="prev page">
        <i class="iconfont icon-right"></i>
      </div>
      <div class="next page">
        <i class="iconfont icon-right"></i>
      </div>
    </div>
    <!---->
    <div class="center" style="display: none;">
      <div class="nothing">NOTHING IS IMPOSSIBLE</div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['current_article', 'full_screen'],
  methods: {
    del_tag: function() {},
    add_tag: function() {},
    thumbs_up: function(rss) {
      var that = this;
      axios
        .put(
          window.location.href + "rss_feeds/toggle_thumbs_up",
          {
            user_id: user_id,
            rss_feed_id: rss,
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
    full_screen_mode: function() {
      this.$emit('full_screen_mode')
    },
    create_qr_code: function(url) {
      //        this.qrcode.clear
      //    if(this.qrcode == null) {
      //    this.qrcode = this.$refs.qrcode2
      //}
      if (this.$refs.qrcode != null) {
        this.$refs.qrcode.innerHTML = "";
      }
      console.log(this.qrcode);
      this.qrcode = new QRCode(this.$refs.qrcode, {
        text: url,
        width: 100,
        height: 100,
        colorDark: "#000000",
        colorLight: "#ffffff",
        correctLevel: QRCode.CorrectLevel.H
      });
    }
  }
};
</script>

<style scoped></style>
