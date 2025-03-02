import cloudinary.uploader

def upload_file(file):
    """Uploads a file to Cloudinary and returns the URL."""
    upload_result = cloudinary.uploader.upload(file)
    return upload_result.get("secure_url")

def delete_file(public_id):
    """Deletes a file from Cloudinary using its public ID."""
    cloudinary.uploader.destroy(public_id)