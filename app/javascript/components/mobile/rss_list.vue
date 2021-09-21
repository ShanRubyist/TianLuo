<template>
  <div>
    <a-button @click="window.location.href = 'rss'">查看全部RSS</a-button>

    <a-button @click="mark_readed">一键标记为已读</a-button>

    <div v-for="rss in rss_list_json">
      <!-- <p v-if="is_last_read_position(rss).call()" id="last_read_position">上次读到这里</p> -->

      <div class="rss-list">
        <p class="rss-list-title" v-on:click="go_to_read(rss.link)">
          <a-tooltip placement="top">
            <template slot="title">点击访问源网页</template>
            {{ rss.title }}
          </a-tooltip>
        </p>

        <p class="rss-list-content" v-html="rss.description.substring(0, 1000)"></p>

        <p class="rss-list-footer">
          <a-tooltip placement="top">
            <template slot="title">
              <p>{{ rss.rss_description }}</p>
            </template>
            <small>点击访问RSS源</small>

            <span v-on:click="go_to_read(rss.rss_link)">{{ rss.rss }}</span>
          </a-tooltip>|
          <a-tooltip placement="top">
            <template slot="title">
              <span>作者</span>
            </template>
            {{ rss.author }}
          </a-tooltip>
          | 发布时间：{{ rss.pub_date }}
        </p>
      </div>
    </div>

    <a-spin :spinning="spinning" tip="Loading...">
      <div class="spin-content">
        <a-button id="loadmore" type="primary" @click="loadmore">加载更多</a-button>
      </div>
    </a-spin>
  </div>
</template>

<script>
export default {
  props: ["user_id", "rss_list_json"],
  data: function() {
    return {
      prev: null,
      next_page: 2,
      spinning: false
    };
  },
  methods: {
    mark_readed: function() {
      var that = this;
      axios
        .put(
          window.location.href + "rss_feeds/mark_readed",
          {
            user_id: user_id,
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
    is_last_read_position: function(current) {
      // 必须是闭包函数，否则只会是false
      return function() {
        // 上个RSS Feed为空或未读，并且当前RSS Feed为已读
        if (
          (this.prev == null || this.prev.status == true) &&
          current.status == false
        ) {
          this.prev = current;
          return true;
        } else {
          this.prev = current;
          return false;
        }
      };
    },
    append_rss_feed: function(data) {
      var that = this;
      data.forEach(function(obj, index) {
        that.rss_list_json.push(obj);
      });
      //   console.log(this.rss_list_json)
    },
    go_to_read: function(link) {
      window.open(link);
    },
    loadmore: function() {
      let that = this;
      that.spinning = true;

      axios
        .get("/rss_feeds/load_more_rss_feed", {
          params: {
            user_id: user_id,
            page: this.next_page,
            per: 100
          }
        })
        .then(function(reason) {
          that.spinning = false;
          that.append_rss_feed(reason.data);
          that.next_page += 1;
        })
        .catch(function(reason) {
          that.spinning = false;
          that.$message.error("加载出错!");
        });
    }
  }
};
</script>

<style scoped></style>
