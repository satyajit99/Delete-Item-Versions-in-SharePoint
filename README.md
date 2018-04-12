# Delete-Item-Versions-in-SharePoint
Script to delete the item versions of a library, based on various criteria such as, CreatedDate, VersionLabel, etc.

This script has three modes – 

•	Delete item versions in SharePoint using PowerShell – Report Mode
This gives the report of the item versions that will be deleted, but will not delete anything. This is useful for analyzing the files before the decision is being made for deletion.

•	Delete item versions in SharePoint using PowerShell – Recycle Mode
This mode will send the identified versions to the Recycle Bin rather than deleting them permanently. The report generated at the end will indicate the item versions moved to the Recycle Bin

•	Delete item versions in SharePoint using PowerShell – Permanent Delete Mode
This mode will delete the identified versions permanently. Once deleted, the versions cannot be retrieved. The report generated at the end will indicate the item versions that have been successfully deleted.


However, it is to be noted that the current version of the document (Current Major Version and current Minor Version) will not be deleted, even if it falls into the category.  This script will also let us users know of the storage size saved by means of deletion of the versions.
