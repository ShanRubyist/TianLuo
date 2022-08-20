<template>
  <div v-show="!full_screen" id="article_list" class="article-list">
    <div class="drag-area"></div>
    <div class="flexbox article-list__toolbar search-header"
      style="justify-content: space-between; align-items: center; flex-wrap: nowrap;">
      <div class="search-input el-input el-input--prefix el-input--suffix">
        <!---->
        <input type="text" autocomplete="off" placeholder="搜索所有文章" class="el-input__inner" />
        <span class="el-input__prefix">
          <i class="el-input__icon el-icon-search"></i>
          <!---->
        </span>
        <!---->
        <!---->
      </div>
      <div title="只看未读/查看全部" class="article-list__toolbar-unread active"></div>
    </div>
    <!---->
    <div v-if="has_new_articles() && is_status_change()" class="article-list__refresh">
      <span @click='$emit("refresh_list", current_rss)' class="article-list__refresh-tip">
        订阅有 {{ new_articles_count() }} 篇新文章、{{ change_articles_count() }} 篇文章状态有变化，点击刷新</span>
    </div>
    <div v-else-if="has_new_articles()" class="article-list__refresh">
      <span @click='$emit("refresh_list", current_rss)' class="article-list__refresh-tip">
        订阅有 {{ new_articles_count() }} 篇新文章，点击刷新</span>
    </div>
    <div v-else-if="is_status_change()" class="article-list__refresh">
      <span @click='$emit("refresh_list", current_rss)' class="article-list__refresh-tip">
        订阅有 {{ change_articles_count() }} 篇文章状态有变化，点击刷新</span>
    </div>

    <div v-loading="article_list_loading" ref="article_list" class="article-list__main text-list" id="article-list__main">
      <div v-for="rss in rss_list_json" class="article-item feeds-expanded sm-text text-list"
        :class="{ read: rss.status, active: (current_article == rss) }" @click="change_article(rss)">
        <div class="article-item__wrapper">
          <div class="flexbox article-item__text-wrapper"
            style="justify-content: space-between; align-items: center; flex-wrap: wrap;">
            <img lazyload="auto" :src="rss.icon" :alt="rss.description" class="avatar--sm article-item__meta-favicon" />
            <span class="article-item__meta-title text--ellipsis">{{ rss.rss }}</span>
            <span class="article-item__meta-date">
              <time :datetime="rss.pub_date" class="el-tooltip item">{{ rss.pub_date }}</time>
            </span>
            <h6 class="article-item__title">{{ rss.title }}</h6>
          </div>
        </div>
      </div>
      <div data-v-9ac9b68a class="infinite-loading-container">
        <div data-v-9ac9b68a v-if="load_more_loading">
          <i data-v-10a220cc data-v-9ac9b68a class="loading-default"></i>
        </div>
        <div data-v-9ac9b68a class="infinite-status-prompt" style="display: none;">No results :(</div>
      </div>
      <div data-v-9ac9b68a class="infinite-status-prompt" style="display: none;">No more
        data :)</div>

      <hr data-content="这是底线" class="hr-text" />
      <div class="article-list__bottom-toolbar">
        <div role="progressbar" aria-valuenow="1" aria-valuemin="0" aria-valuemax="100"
          class="el-progress el-progress--line el-progress--without-text">
          <div class="el-progress-bar">
            <div class="el-progress-bar__outer" style="height: 1px;">
              <div class="el-progress-bar__inner" style="width: 1%; background-color: rgb(245, 108, 108);">
              </div>
            </div>
          </div>
        </div>
        <div class="flexbox bottom-toolbar__content"
          style="justify-content: space-between; align-items: center; flex-wrap: nowrap;">
          <div class="bottom-toolbar__left">
            <span>
              <i class="iconfont icon-layout el-popover__reference" aria-describedby="el-popover-7006" tabindex="0"></i>
            </span>
          </div>
          <span class="bottom-toolbar__label">{{ current_page }} / {{ total_page }}</span>
          <div class="bottom-toolbar__right">
            <span>
              <i class="iconfont icon-more el-popover__reference" aria-describedby="el-popover-7846" tabindex="0"></i>
            </span>
            <i class="iconfont icon-unfold collase-detail__arrow" @click="next_page()"
              style="transform: rotate(180deg);"></i>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
export default {
  props: ["full_screen", "rss_list_json", "rss_list_json1",
    "current_article", "current_rss", "article_list_loading",
    "current_page", "total_num", "latest_total_num",
    "latest_unread_count", "unread_count_of_current_rss"],
  data: function () {
    return {
      load_more_loading: false,
      unread_count: this.unread_count_of_current_rss,
      total_page:
          this.total_num == 0 ? 1 : (Math.floor(this.total_num / 100) + ((this.total_num % 100 == 0) ? 0 : 1))
    };
  },
  methods: {
    change_article: function (article) {
      this.$emit('change_article', article)
    },
    next_page: async function () {
      var that = this;

      if (this.current_page == this.total_page) {
        return;
      }

      try {
        // app.__vue__.article_list_loading = true;
        that.load_more_loading = true;
        let promise = axios
          .get("/rss_list", {
            headers: {
              Accept: "application/json"
            },
            params: {
              user_id: user_id,
              rss: that.current_rss,
              page: that.current_page + 1,
            }
          })

        let response = await promise;
        // console.log(response.data)

        that.$emit('next_page', response.data.data)
        that.load_more_loading = false;
      } catch (error) {
        that.$message.error(error.toString());
      };
    },
    has_new_articles: function () {
      if (this.latest_total_num && (this.latest_total_num > this.total_num)) {
        return true
      }
      else {
        return false
      }
    },
    is_status_change: function () {
      if (this.latest_unread_count == null){
        return false;
      }

      // 无新文章时，latest_unread_count != unread_count;
      // 有新文章是，latest_unread_count != unread_count + 新文章数量;
      if ((this.latest_unread_count - this.unread_count) != (this.latest_total_num - this.total_num)) {
        return true
      }
      else {
        return false
      }
    },
    new_articles_count: function (){
      if (this.latest_total_num) {
        let result = this.latest_total_num - this.total_num;
        return (result > 999 ? "999+" : result);
      }
      else {
        return 0
      }
    },
    change_articles_count: function () {
      if (this.latest_unread_count != null) {
        let result = Math.abs(this.latest_unread_count - this.unread_count);
        return (result > 999 ? "999+" : result);
      } else {
        return 0;
      }
    }
  },
  watch: {
    current_rss: function() {
      this.$refs.article_list.scrollTop = 0;
    },
    total_num: function() {
      if (this.total_num == 0) {
        this.total_page = 1
      } else {
        this.total_page =
            Math.floor(this.total_num / 100) + ((this.total_num % 100 == 0) ? 0 : 1)
      }
    },
    unread_count_of_current_rss: function() {
      this.unread_count = this.unread_count_of_current_rss;
    }
  }
};
</script>

<style scoped>
</style>
