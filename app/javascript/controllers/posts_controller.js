import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

export default class extends Controller {
  static targets = ["post"];

  async delete(event) {
    event.preventDefault();

    const postId = this.element.dataset.postId; // ดึง id ของโพสต์จาก dataset
    const confirmDelete = confirm("Are you sure you want to delete this post?");
    if (!confirmDelete) return;

    try {
      // ส่งคำขอ DELETE ผ่าน fetch
      const response = await fetch(`/posts/${postId}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
          'Content-Type': 'application/json',
        },
      });

      if (response.ok) {
        alert("Post deleted successfully!");
        // ลบ Element ของโพสต์ออกจาก DOM
        this.element.remove(); 

        // ใช้ Turbo เพื่อทำการโหลดใหม่บางส่วนถ้าจำเป็น
        Turbo.visit(window.location.href, { action: "replace" });
      } else {
        const error = await response.json();
        alert(`Error: ${error.error}`);
      }
    } catch (err) {
      console.error("Error:", err);
      alert("Failed to delete post.");
    }
  }
}
