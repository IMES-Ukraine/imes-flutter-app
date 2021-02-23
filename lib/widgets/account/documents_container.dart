import 'package:flutter/material.dart';
import 'package:imes/models/cover_image.dart';

import 'package:sizer/sizer.dart';

class DocumentsContainer extends FormField<CoverImage> {
  final CoverImage doc;
  final VoidCallback onTap;
  final VoidCallback onDeleteTap;

  DocumentsContainer({Key key, this.doc, this.onTap, this.onDeleteTap})
      : super(
          builder: (state) {
            final context = state.context;
            return InkResponse(
              onTap: onTap,
              child: Row(
                children: [
                  Icon(Icons.file_upload,
                      color: state.hasError ? Theme.of(context).errorColor : Theme.of(context).primaryColor,
                      size: 3.0.h),
                  SizedBox(width: 1.0.h),
                  Expanded(
                    child: Text(
                      doc?.fileName ?? 'Завантажити',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: state.hasError ? Theme.of(context).errorColor : Theme.of(context).primaryColor,
                          fontSize: 10.0.sp),
                    ),
                  ),
                  if (doc != null)
                    IconButton(
                      icon: Icon(Icons.delete, color: Theme.of(context).primaryColor, size: 3.0.h),
                      onPressed: onDeleteTap,
                    ),
                ],
              ),
            );
          },
          initialValue: doc,
          validator: (value) => doc != null ? null : '',
        );
}
