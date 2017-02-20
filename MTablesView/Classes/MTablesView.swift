//
//  MTablesView.swift
//  Pods
//
//  Created by Ziyin Wang on 2017-02-18.
//
//

import UIKit

@available(iOS 9.0, *)
public class MTablesView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    lazy var closeAndBackButton:UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(closeOrBack(sender:)), for: .touchUpInside)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "TITLE"
        return label
    }()
    
    lazy var mainTable:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(MainTableCell.self, forCellReuseIdentifier: "MainCell")
        return table
    }()
    
    lazy var detailedTable:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(DetailTableCell.self, forCellReuseIdentifier: "DetailCell")
        return table
    }()
    
    let topView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    
    var viewTitle:String?
    
    var sectionTitles:Array<String>?
    
    var mainData:[[String]]?
    
    var detailedData:[[[String]]]?
    
    var selectedDetailData:[String]?
    
    var tableLeftAnchor:NSLayoutConstraint?
    
    public var delegate:MTableViewDelegate?
    
    public init(viewTitle:String, sectionTitles:Array<String>, mainData:[[String]]?, detailedData:[[[String]]]?)
    {
        super.init(frame: .zero)
        self.viewTitle = viewTitle
        self.sectionTitles = sectionTitles
        self.mainData = mainData
        self.detailedData = detailedData
        
        addSubview(mainTable)
        addSubview(detailedTable)
        addSubview(topView)
        topView.addSubview(titleLabel)
        topView.addSubview(closeAndBackButton)
        
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        topView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        closeAndBackButton.translatesAutoresizingMaskIntoConstraints = false
        closeAndBackButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        closeAndBackButton.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -8).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        
        let anchors = mainTable.anchor(topView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right:nil, topConstant: -20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        mainTable.widthAnchor.constraint(equalTo: widthAnchor, constant: 0).isActive = true
        tableLeftAnchor = anchors[2]
        
        detailedTable.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: -20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        detailedTable.widthAnchor.constraint(equalTo: widthAnchor, constant: 0).isActive = true
        bringSubview(toFront: mainTable)
        bringSubview(toFront: topView)
    }
    
    func closeOrBack(sender:UIButton)
    {
        if sender.currentTitle == "Done"
        {
            delegate?.moveBackView()
        }
        else if sender.currentTitle == "Back"
        {
            sender.setTitle("Done",for:.normal)
            moveTable()
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == mainTable
        {
            if let title = sectionTitles?[section]
            {
                return title
            }
        }
        return ""
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == mainTable
        {
            if let data = mainData
            {
                return data.count
            }
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == mainTable
        {
            if let data = mainData?[section]
            {
                return data.count
            }
        }
        if tableView == detailedTable
        {
            if let data = selectedDetailData
            {
                return data.count
            }
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == mainTable
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainTableCell
            if let data = mainData?[indexPath.section]
            {
                cell.textLabel?.text = data[indexPath.row]
            }
            return cell;
        }
        if tableView == detailedTable
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailTableCell
            
            if let text = selectedDetailData?[indexPath.row]
            {
                cell.textLabel?.text = text
            }
            return cell;
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == mainTable
        {
            selectedDetailData = detailedData?[indexPath.section][indexPath.row]
            detailedTable.reloadData()
            closeAndBackButton.setTitle("Back", for: .normal)
            moveTable()
        }
    }
    
    private func moveTable()
    {
        tableLeftAnchor?.isActive = false
        if closeAndBackButton.currentTitle == "Back"
        {
            tableLeftAnchor?.constant = -frame.size.width
        }
        else if closeAndBackButton.currentTitle == "Done"
        {
            mainTable.deselectRow(at: mainTable.indexPathForSelectedRow!, animated: true)
            tableLeftAnchor?.constant = 0
        }
        tableLeftAnchor?.isActive = true
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        })
    }
}

public protocol MTableViewDelegate {
    
    func moveBackView()
}
