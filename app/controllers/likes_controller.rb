class LikesController < ApplicationController
  def create
    @like = current_user.likes.new(like_params)
    @post = Post.find(like_params[:post_id]) # เพื่อใช้ใน response
    if @like.save
      respond_to do |format|
        format.html { redirect_to post_path(@post), notice: "You liked this post." }
        format.js   # Renders create.js.erb
      end
    else
      flash[:alert] = "Unable to like this post."
      redirect_to post_path(@post)
    end
  end

  def destroy
    @like = current_user.likes.find(params[:id])
    @post = @like.post # ใช้ post ใน response
    @like.destroy
    respond_to do |format|
      format.html { redirect_to post_path(@post), notice: "You unliked this post." }
      format.js   # Renders destroy.js.erb
    end
  end

  private

  def like_params
    params.require(:like).permit(:post_id)
  end
end
