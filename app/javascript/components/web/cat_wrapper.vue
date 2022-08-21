<template>
  <div v-if="cat_wrapper_visible && !full_screen" class="cat-wrapper" style="flex-basis: 216px;">
    <div class="expanded-cat">
      <div class="drag-area"></div>

      <div id="category_list" class="cat-list">
        <div
          class="flexbox cat-list__title"
          style="justify-content: space-between; align-items: center; flex-wrap: nowrap;"
        >
          <span class="cat-list__title-text">订阅列表</span>
          <i class="iconfont icon-reload" @click="refresh_feeds"></i>
          <i class="iconfont icon-plus-circle-o"></i>
        </div>
        <div class="cat-list__filter el-input el-input--prefix el-input--suffix">
          <input type="text" autocomplete="off" placeholder="筛选订阅" class="el-input__inner" />
          <span class="el-input__prefix">
            <i class="el-input__icon el-icon-search"></i>
          </span>
        </div>
        <div class="cat-list__content">
          <div>
            <div class="draggable-item">
              <div title="{{ this.unread_count }} 篇未读文章" class="nav-item cat-item">
                <i class="iconfont icon-unfold"></i>
                <span
                    class="nav-item__title text--ellipsis"
                    @click="$emit('change_rss', null)"
                >全部
                </span>
                <a-popover>
                  <template slot="content">
                    <ul class="el-popover__menu">
                      <li @click="mark_readed" class="el-popover__menu-item">设为已读</li>
                    </ul>
                  </template>
                  <div class="nav-item__count">
                    <span>{{unread_count}}</span>
                  </div>

                  <!--                  <i class="iconfont icon-more el-popover__reference" aria-describedby="el-popover-8372" tabindex="0"></i>-->
                </a-popover>
              </div>
            </div>
            <div style>
              <div v-for="rss in all_rss_list_json" class="nav-item">
                <template v-if="rss.status == 'enqueued' || rss.status == 'performing'">
                  <a-space><a-spin :spinning="true" size="small" /></a-space>
                </template>
                <template v-else-if="rss.status == 'fail'">
                    <i class="iconfont icon-error"></i>
                </template>

                <span
                  class="nav-item__title text--ellipsis"
                  @click="$emit('change_rss', rss.probe_settings_id)"
                >{{rss.title}}
                </span>


                <a-popover>
                  <template slot="content">
                    <ul class="el-popover__menu">
                      <li class="el-popover__menu-item">编辑分组</li>
                      <li class="el-popover__menu-item">设为已读</li>
                      <li class="el-popover__menu-item">取消订阅</li>
                      <li class="el-popover__menu-item">修改标题</li>
                      <li class="el-popover__menu-item">查看源信息</li>
                    </ul>
                  </template>
                  <div class="nav-item__count">
                    <span>{{rss.unread_count}}</span>
                  </div>
                </a-popover>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["all_rss_list_json", "cat_wrapper_visible", "full_screen", "unread_count"],
  methods: {
    mark_readed: function() {
      var that = this;
      axios
        .put(
          window.location.href + "rss_feeds/mark_all_as_read",
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
    refresh_feeds: function(type) {
      var that = this;
      axios
        .post(
          "/start_all_jobs",
          {
            type: type,
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
  }
};
</script>

<style scoped></style>
