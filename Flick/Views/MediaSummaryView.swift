//
//  MediaSummaryView.swift
//  Flick
//
//  Created by Lucy Xu on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaSummaryView: UIView {

    // MARK: - Private View Vars
    private var platformCollectionView: SelfSizingCollectionView!
    private var summaryItemsCollectionView: SelfSizingCollectionView!
    private let summaryLabel = UILabel()
    private var tagsCollectionView: SelfSizingCollectionView!
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private let platformCellReuseIdentifier = "PlatformCellReuseIdentifier"
    private let summaryInfoCellReuseIdentifier = "SummaryInfoCellReuseIdentifier"
    private let tagCellReuseIdentifier = "TagCellReuseIdentifier"

    // TODO: Update media with backend values
    private let mediaTitle = "Spiderman: Far From Home"
    private let mediaSummary = "In May 1940, Germany advanced into France, trapping Allied troops on the beaches of Dunkirk. Under air and ground cover from British and French forces, troops were slowly and methodically evacuated from the beach using every serviceable naval and civilian vessel that could be found. At the end of this heroic mission, 330,000 French, British, Belgian and Dutch soldiers were safely evacuated."
    private let summaryInfo = [
        MediaSummary(text: "1h 30", type: .duration),
        MediaSummary(type: .spacer),
        MediaSummary(text: "2019", type: .year),
        MediaSummary(type: .spacer),
        MediaSummary(text: "Released", type: .releaseStatus),
        MediaSummary(type: .spacer),
        MediaSummary(text: "PG-13", type: .rating),
        MediaSummary(type: .spacer),
        MediaSummary(text: "EN", type: .language),
        MediaSummary(type: .spacer),
        MediaSummary(text: "Quentin Tarantino", type: .director)
    ]
    private let tags = ["Comedy", "Romance", "Superhero", "FBI", "Romantic Comedy", "Crime", "Sad"]
    private let platforms = ["Netflix", "Hulu"]

    override init(frame: CGRect) {
        super.init(frame: frame)

        print(self.bounds.height)

        titleLabel.text = mediaTitle
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .darkBlue
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.sizeToFit()
        addSubview(titleLabel)

        let summaryItemsCollectionViewLayout = LeftAlignedFlowLayout()
        summaryItemsCollectionView = SelfSizingCollectionView(
            frame: CGRect(x: 0, y: 0, width: frame.width, height: 0),
            collectionViewLayout: summaryItemsCollectionViewLayout
        )
        summaryItemsCollectionView.backgroundColor = .clear
        summaryItemsCollectionView.register(MediaSummaryInfoCollectionViewCell.self, forCellWithReuseIdentifier: summaryInfoCellReuseIdentifier)
        summaryItemsCollectionView.dataSource = self
        summaryItemsCollectionView.delegate = self
        summaryItemsCollectionView.layoutIfNeeded()
        addSubview(summaryItemsCollectionView)

        summaryLabel.text = mediaSummary
        summaryLabel.font = .systemFont(ofSize: 14)
        summaryLabel.frame = CGRect(x: 0, y: 0, width: frame.width - 20, height: .greatestFiniteMagnitude)
        summaryLabel.textColor = .darkBlue
        summaryLabel.numberOfLines = 0
        summaryLabel.sizeToFit()
        addSubview(summaryLabel)

        let tagsCollectionViewLayout = LeftAlignedFlowLayout()
        tagsCollectionView = SelfSizingCollectionView(
            frame: CGRect(x: 0, y: 0, width: frame.width, height: 0),
            collectionViewLayout: tagsCollectionViewLayout)
        tagsCollectionView.backgroundColor = .clear
        tagsCollectionView.register(MediaTagCollectionViewCell.self, forCellWithReuseIdentifier: tagCellReuseIdentifier)
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        tagsCollectionView.layoutIfNeeded()
        addSubview(tagsCollectionView)

        let platformFlowLayout = UICollectionViewFlowLayout()
        platformFlowLayout.minimumInteritemSpacing = 12
        platformCollectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: platformFlowLayout)
        platformCollectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        platformCollectionView.backgroundColor = .clear
        platformCollectionView.register(MediaTagCollectionViewCell.self, forCellWithReuseIdentifier: platformCellReuseIdentifier)
        platformCollectionView.dataSource = self
        platformCollectionView.delegate = self
        platformCollectionView.layoutIfNeeded()
        addSubview(platformCollectionView)

        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let verticalPadding = 12
        let horizontalPadding = 10

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(horizontalPadding*2)
        }

        summaryItemsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(titleLabel)
        }

        summaryLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(summaryItemsCollectionView.snp.bottom).offset(16)
        }

        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalTo(titleLabel)
        }

        platformCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagsCollectionView.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalTo(titleLabel)
        }
    }

    override var intrinsicContentSize: CGSize {
        let width = frame.size.width
        let titleLabelHeight = titleLabel.frame.height
        let summaryItemsCollectionViewHeight = summaryItemsCollectionView.contentSize.height
        let summaryLabelHeight = summaryLabel.frame.height
        let tagsCollectionViewHeight = tagsCollectionView.contentSize.height
        let platformCollectionViewHeight = platformCollectionView.contentSize.height
        let totalLabelHeight = titleLabelHeight + summaryLabelHeight
        let totalCollectionViewHeight = summaryItemsCollectionViewHeight + tagsCollectionViewHeight + platformCollectionViewHeight
        let totalVerticalPadding: CGFloat = 56
        let height = totalVerticalPadding + totalLabelHeight + totalCollectionViewHeight
        return CGSize(width: width, height: height)
    }
}

extension MediaSummaryView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == summaryItemsCollectionView {
            return summaryInfo.count
        } else if collectionView == tagsCollectionView {
            return tags.count
        } else {
            return platforms.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == summaryItemsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: summaryInfoCellReuseIdentifier, for: indexPath) as? MediaSummaryInfoCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: summaryInfo[indexPath.item])
            return cell
        } else if collectionView == tagsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellReuseIdentifier, for: indexPath) as? MediaTagCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: tags[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: platformCellReuseIdentifier, for: indexPath)
            cell.layer.cornerRadius = 5
            cell.layer.backgroundColor = UIColor.gray.cgColor
            return cell
        }
    }
}

extension MediaSummaryView: UICollectionViewDelegateFlowLayout {
    func calculateNecessaryWidth(text: String) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12)
        label.sizeToFit()
        return label.frame.width
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == summaryItemsCollectionView {
            let textWidth = calculateNecessaryWidth(text: summaryInfo[indexPath.item].text)
            let height: CGFloat = 15
            let iconSpacerWidth: CGFloat = 19
            switch summaryInfo[indexPath.item].type {
            case .spacer:
                return CGSize(width: 10, height: height)
            case .director:
                return CGSize(width: textWidth + iconSpacerWidth, height: height)
            case .duration:
                return CGSize(width: textWidth + iconSpacerWidth, height: height)
            case .rating:
                return CGSize(width: textWidth + 8, height: height + 4)
            default:
                return CGSize(width: textWidth, height: height)
            }
        } else if collectionView == tagsCollectionView {
            let totalHorizontalPadding: CGFloat = 32
            return CGSize(width: calculateNecessaryWidth(text: tags[indexPath.item]) + totalHorizontalPadding, height: 27)
        } else {
            return CGSize(width: 26, height: 26)
        }
    }
}
