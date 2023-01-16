//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 1/16/23.
//

import Foundation

public final class ImageCommentsPresenter {
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: Self.self),
                                 comment: "Title for image comments view")
    }
}
