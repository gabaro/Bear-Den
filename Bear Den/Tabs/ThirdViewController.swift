//
//  ThirdViewController.swift
//  Bear Den
//
//  Created by Genevieve Garrison on 2/20/19.
//  Copyright © 2019 Gabaro 2019. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ThirdViewController: UIViewController
{

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    let numberOfRows = 6
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureCalendarView()
    }
    
    func configureCalendarView()
    {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.register(UINib(nibName: "CalendarSectionHeaderView", bundle: Bundle.main),forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:"CalendarSectionHeaderView")
        self.calendarView.scrollToDate(Date(),animateScroll: false)
        self.calendarView.selectDates([  Date() ])
    }
    
    func configureCell(cell: JTAppleCell?, cellState: CellState)
    {
        guard let currentCell = cell as? CustomCell else{
            return
        }
        currentCell.dateLabel.text = cellState.text
        configureSelectedStateFor(cell: currentCell, cellState: cellState)
        configureTextColorFor(cell: currentCell, cellState: cellState)
        let cellHidden = cellState.dateBelongsTo != .thisMonth
        currentCell.isHidden = cellHidden
        
    }
    
    func configureTextColorFor(cell: JTAppleCell?, cellState: CellState)
    {
        guard let currentCell = cell as? CustomCell else{
            return
        }
        
        if cellState.isSelected{
            currentCell.dateLabel.textColor = UIColor.black
        }else{
            if cellState.dateBelongsTo == .thisMonth && cellState.date > Date(){
                currentCell.dateLabel.textColor = UIColor.white
            }else{
                currentCell.dateLabel.textColor = UIColor.gray
            }
        }
    }

    func configureSelectedStateFor(cell: JTAppleCell?, cellState: CellState)
    {
        guard let currentCell = cell as? CustomCell else{
            return
        }
        if cellState.isSelected{
            currentCell.selectedView.isHidden = false
        }else{
            currentCell.selectedView.isHidden = true
        }
    }
}

extension ThirdViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters
    {
        formatter.dateFormat = "dd MM yy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        calendar.scrollingMode = .stopAtEachSection
        
        let startDate = formatter.date(from: "28 08 19")
        let endDate = formatter.date(from: "31 05 20")
        
        let paramaters = ConfigurationParameters(startDate: startDate!,
                                                 endDate: endDate!,
                                                 numberOfRows: numberOfRows,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfRow,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: true)
        return paramaters
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath){
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        configureCell(cell: cell, cellState: cellState)
    }
}
extension ThirdViewController: JTAppleCalendarViewDelegate{
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        configureCell(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "CalendarSectionHeaderView", for: indexPath)
        let date = range.start
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        (header as! CalendarSectionHeaderView).title.text = formatter.string(from: date)
        return header
    }
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 40)
    }
    
}
