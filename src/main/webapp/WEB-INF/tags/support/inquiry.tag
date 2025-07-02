<%@ tag language="java" pageEncoding="UTF-8"%>

<script src="${cpath}/resources/js/summernote/summernote-lite.js"></script>
<script src="${cpath}/resources/js/board.js"></script>
<div class="w-full grid grid-cols-1 lg:grid-cols-5">
	<div class="col-span-4 w-full h-full flex flex-col gap-y-4 bg-gray-8 p-4">
		<input type="text" id="title" name="title" class="text-3xl font-extrabold bg-transparent outline-none" placeholder="제목을 입력하세요">
		<div class="w-full bg-white">
			<textarea id="summernote" name="content"></textarea>
		</div>
	</div>
	<div class="col-span-1 flex lg:flex-col items-center justify-end gap-4 bg-blue-4 p-4 font-bold text-white text-base md:text-lg lg:text-xl">
		<button class="w-full bg-blue-3 hover:bg-blue-4 rounded-full py-2.5" onclick="history.back()">취소하기</button>
		<button class="w-full bg-blue-2 hover:bg-blue-1 rounded-full py-2.5">문의하기</button>
	</div>
</div>
<script>
	$(document).ready(function() {
		if ($('#summernote').length) {
			$('#summernote').summernote({
				height : 400,
				lang : "ko-KR",
				placeholder : '최대 2048자까지 쓸 수 있습니다',
				callbacks : {
					onImageUpload : function(files) {
						uploadSummernoteImageFile(files[0], this);
					},
					onPaste : function(e) {
						var clipboardData = e.originalEvent.clipboardData;
						
						if (clipboardData && clipboardData.items && clipboardData.items.length) {
							var item = clipboardData.items[0];
							
							if (item.kind === 'file'&& item.type.indexOf('image/') !== -1) {
								e.preventDefault();
							}
						}
					}
				}
			});

			// 이미지 업로드 함수
			function uploadSummernoteImageFile(file, editor) {
				let data = new FormData();
				
				data.append("image", file);

				$.ajax({
					data : data,
					type : "POST",
					url : "/api/board/image-upload",
					contentType : false,
					processData : false,
					success : function(data) {
						$(editor).summernote('insertImage', data.url);
					},
					error : function() {
						alert("이미지 업로드에 실패했습니다.");
					}
				});
			}
		}
	});
</script>