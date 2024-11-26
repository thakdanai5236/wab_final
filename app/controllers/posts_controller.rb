class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show search]
  before_action :authorize_user!, only: %i[edit update destroy]

  # GET /posts or /posts.json
  def index
    if params[:search].present?
      @posts = Post.where("title LIKE ?", "%#{params[:search]}%") # ค้นหาจาก title
    else
      @posts = Post.all # แสดงโพสต์ทั้งหมด
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comment = @post.comments.build # สำหรับสร้างคอมเมนต์ใหม่ในหน้าโพสต์
  end

  # GET /posts/myposts
  def myposts
    # ดึงโพสต์ที่ผู้ใช้ล็อกอินเป็นคนสร้าง (ตาม user_id)
    @posts = current_user.posts # แสดงโพสต์เฉพาะของผู้ใช้ที่ล็อกอิน
  end

  # GET /posts/new
  def new
    @post = Post.new # สร้างโพสต์ใหม่
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params) # ผูกโพสต์กับผู้ใช้ที่สร้าง

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # GET /posts/search
  def search
    if params[:q].present?
      @posts = Post.where("title ILIKE ? OR description ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
      if @posts.empty?
        flash.now[:alert] = "No posts found for '#{params[:q]}'"
      end
    else
      @posts = Post.none
      flash.now[:alert] = "Please enter a keyword to search"
    end
    render :search_results
  end

  private

  # ค้นหาโพสต์ที่ต้องการจาก ID
  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: "Post not found"
  end

  # ตรวจสอบสิทธิ์ผู้ใช้ก่อนแก้ไข/ลบ
  def authorize_user!
    unless @post.user == current_user
      redirect_to posts_path, alert: "You are not authorized to perform this action."
    end
  end

  # อนุญาตเฉพาะฟิลด์ที่เชื่อถือได้
  def post_params
    params.require(:post).permit(:title, :description, :keyword, :image)
  end
end
