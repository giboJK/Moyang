//
//  Bible.swift
//  Moyang
//
//  Created by kibo on 2022/08/23.
//

import Foundation

class BibleInfo {
    enum OldTestament: Int {
        case Genesis = 0
        case Exodus
        case Leviticus
        case Numbers
        case Deuteronomy
        case Joshua
        case Judges
        case Ruth
        case SamuelOne
        case SamuelTwo
        case KingsOne
        case KingsTow
        case ChroniclesOne
        case ChroniclesTwo
        case Ezra
        case Nehemiah
        case Esther
        case Job
        case Psalms
        case Proverbs
        case Ecclesiastes
        case SongOfSongs
        case Isaiah
        case Jeremiah
        case Lamentations
        case Ezekiel
        case Daniel
        case Hosea
        case Joel
        case Amos
        case Obadiah
        case Jonah
        case Micah
        case Nahum
        case Habakkuk
        case Zephaniah
        case Haggai
        case Zechariah
        case Malachi
        
        var bookName: String {
            switch self {
            case .Genesis:
                return "창세기"
            case .Exodus:
                return "출애굽기"
            case .Leviticus:
                return "레위기"
            case .Numbers:
                return "민수기"
            case .Deuteronomy:
                return "신명기"
            case .Joshua:
                return "여호수아"
            case .Judges:
                return "사사기"
            case .Ruth:
                return "룻기"
            case .SamuelOne:
                return "사무엘상"
            case .SamuelTwo:
                return "사무엘하"
            case .KingsOne:
                return "열왕기상"
            case .KingsTow:
                return "열왕기하"
            case .ChroniclesOne:
                return "역대상"
            case .ChroniclesTwo:
                return "역대하"
            case .Ezra:
                return "에스라"
            case .Nehemiah:
                return "느헤미야"
            case .Esther:
                return "에스더"
            case .Job:
                return "욥기"
            case .Psalms:
                return "시편"
            case .Proverbs:
                return "잠언"
            case .Ecclesiastes:
                return "전도서"
            case .SongOfSongs:
                return "아가"
            case .Isaiah:
                return "이사야"
            case .Jeremiah:
                return "예레미야"
            case .Lamentations:
                return "예레미야애가"
            case .Ezekiel:
                return "에스겔"
            case .Daniel:
                return "다니엘"
            case .Hosea:
                return "호세아"
            case .Joel:
                return "요엘"
            case .Amos:
                return "아모스"
            case .Obadiah:
                return "오바댜"
            case .Jonah:
                return "요나"
            case .Micah:
                return "미가"
            case .Nahum:
                return "나훔"
            case .Habakkuk:
                return "하박국"
            case .Zephaniah:
                return "스바냐"
            case .Haggai:
                return "학개"
            case .Zechariah:
                return "스가랴"
            case .Malachi:
                return "말라기"
            }
        }
    }
    
    enum NewTestament: Int {
        case Matthew = 0
        case Mark
        case Luke
        case John
        case ActsOfTheApostles
        case Romans
        case CorinthiansOne
        case CorinthiansTwo
        case Galatians
        case Ephesians
        case Philippians
        case Colossians
        case ThessaloniansOne
        case ThessaloniansTwo
        case TimothyOne
        case TimothyTwo
        case Titus
        case Philemon
        case Hebrews
        case James
        case PeterOne
        case PeterTwo
        case JohnOne
        case JohnTwo
        case JohnThree
        case Jude
        case Revelation
        
        var bookName: String {
            switch self {
            case .Matthew:
                return "마태복음"
            case .Mark:
                return "마가복음"
            case .Luke:
                return "누가복음"
            case .John:
                return "요한복음"
            case .ActsOfTheApostles:
                return "사도행전"
            case .Romans:
                return "로마서"
            case .CorinthiansOne:
                return "고린도전서"
            case .CorinthiansTwo:
                return "고린도후서"
            case .Galatians:
                return "갈라디아서"
            case .Ephesians:
                return "에베소서"
            case .Philippians:
                return "빌립보서"
            case .Colossians:
                return "골로새서"
            case .ThessaloniansOne:
                return "데살로니가전서"
            case .ThessaloniansTwo:
                return "데살로니가후서"
            case .TimothyOne:
                return "디모데전서"
            case .TimothyTwo:
                return "디모데후서"
            case .Titus:
                return "디도서"
            case .Philemon:
                return "빌레몬서"
            case .Hebrews:
                return "히브리서"
            case .James:
                return "야고보서"
            case .PeterOne:
                return "베드로전서"
            case .PeterTwo:
                return "베드로후서"
            case .JohnOne:
                return "요한일서"
            case .JohnTwo:
                return "요한이서"
            case .JohnThree:
                return "요한삼서"
            case .Jude:
                return "유다서"
            case .Revelation:
                return "요한계시록"
            }
        }
    }
    static let Genesis = BibleBook(type: OldTestament.Genesis.rawValue, bookType: "", bookName: OldTestament.Genesis.bookName, author: "", chapterInfoList: [])
    static let Exodus = BibleBook(type: OldTestament.Exodus.rawValue, bookType: "", bookName: OldTestament.Exodus.bookName, author: "", chapterInfoList: [])
    static let Leviticus = BibleBook(type: OldTestament.Leviticus.rawValue, bookType: "", bookName: OldTestament.Leviticus.bookName, author: "", chapterInfoList: [])
    static let Numbers = BibleBook(type: OldTestament.Numbers.rawValue, bookType: "", bookName: OldTestament.Numbers.bookName, author: "", chapterInfoList: [])
    static let Deuteronomy = BibleBook(type: OldTestament.Deuteronomy.rawValue, bookType: "", bookName: OldTestament.Deuteronomy.bookName, author: "", chapterInfoList: [])
    static let Joshua = BibleBook(type: OldTestament.Joshua.rawValue, bookType: "", bookName: OldTestament.Joshua.bookName, author: "", chapterInfoList: [])
    static let Judges = BibleBook(type: OldTestament.Judges.rawValue, bookType: "", bookName: OldTestament.Judges.bookName, author: "", chapterInfoList: [])
    static let Ruth = BibleBook(type: OldTestament.Ruth.rawValue, bookType: "", bookName: OldTestament.Ruth.bookName, author: "", chapterInfoList: [])
    static let SamuelOne = BibleBook(type: OldTestament.SamuelOne.rawValue, bookType: "", bookName: OldTestament.SamuelOne.bookName, author: "", chapterInfoList: [])
    static let SamuelTwo = BibleBook(type: OldTestament.SamuelTwo.rawValue, bookType: "", bookName: OldTestament.SamuelTwo.bookName, author: "", chapterInfoList: [])
    static let KingsOne = BibleBook(type: OldTestament.KingsOne.rawValue, bookType: "", bookName: OldTestament.KingsOne.bookName, author: "", chapterInfoList: [])
    static let KingsTow = BibleBook(type: OldTestament.KingsTow.rawValue, bookType: "", bookName: OldTestament.KingsTow.bookName, author: "", chapterInfoList: [])
    static let ChroniclesOne = BibleBook(type: OldTestament.ChroniclesOne.rawValue, bookType: "", bookName: OldTestament.ChroniclesOne.bookName, author: "", chapterInfoList: [])
    static let ChroniclesTwo = BibleBook(type: OldTestament.ChroniclesTwo.rawValue, bookType: "", bookName: OldTestament.ChroniclesTwo.bookName, author: "", chapterInfoList: [])
    static let Ezra = BibleBook(type: OldTestament.Ezra.rawValue, bookType: "", bookName: OldTestament.Ezra.bookName, author: "", chapterInfoList: [])
    static let Nehemiah = BibleBook(type: OldTestament.Nehemiah.rawValue, bookType: "", bookName: OldTestament.Nehemiah.bookName, author: "", chapterInfoList: [])
    static let Esther = BibleBook(type: OldTestament.Esther.rawValue, bookType: "", bookName: OldTestament.Esther.bookName, author: "", chapterInfoList: [])
    static let Job = BibleBook(type: OldTestament.Job.rawValue, bookType: "", bookName: OldTestament.Job.bookName, author: "", chapterInfoList: [])
    static let Psalms = BibleBook(type: OldTestament.Psalms.rawValue, bookType: "", bookName: OldTestament.Psalms.bookName, author: "", chapterInfoList: [])
    static let Proverbs = BibleBook(type: OldTestament.Proverbs.rawValue, bookType: "", bookName: OldTestament.Proverbs.bookName, author: "", chapterInfoList: [])
    static let Ecclesiastes = BibleBook(type: OldTestament.Ecclesiastes.rawValue, bookType: "", bookName: OldTestament.Ecclesiastes.bookName, author: "", chapterInfoList: [])
    static let SongOfSongs = BibleBook(type: OldTestament.SongOfSongs.rawValue, bookType: "", bookName: OldTestament.SongOfSongs.bookName, author: "", chapterInfoList: [])
    static let Isaiah = BibleBook(type: OldTestament.Isaiah.rawValue, bookType: "", bookName: OldTestament.Isaiah.bookName, author: "", chapterInfoList: [])
    static let Jeremiah = BibleBook(type: OldTestament.Jeremiah.rawValue, bookType: "", bookName: OldTestament.Jeremiah.bookName, author: "", chapterInfoList: [])
    static let Lamentations = BibleBook(type: OldTestament.Lamentations.rawValue, bookType: "", bookName: OldTestament.Lamentations.bookName, author: "", chapterInfoList: [])
    static let Ezekiel = BibleBook(type: OldTestament.Ezekiel.rawValue, bookType: "", bookName: OldTestament.Ezekiel.bookName, author: "", chapterInfoList: [])
    static let Daniel = BibleBook(type: OldTestament.Daniel.rawValue, bookType: "", bookName: OldTestament.Daniel.bookName, author: "", chapterInfoList: [])
    static let Hosea = BibleBook(type: OldTestament.Hosea.rawValue, bookType: "", bookName: OldTestament.Hosea.bookName, author: "", chapterInfoList: [])
    static let Joel = BibleBook(type: OldTestament.Joel.rawValue, bookType: "", bookName: OldTestament.Joel.bookName, author: "", chapterInfoList: [])
    static let Amos = BibleBook(type: OldTestament.Amos.rawValue, bookType: "", bookName: OldTestament.Amos.bookName, author: "", chapterInfoList: [])
    static let Obadiah = BibleBook(type: OldTestament.Obadiah.rawValue, bookType: "", bookName: OldTestament.Obadiah.bookName, author: "", chapterInfoList: [])
    static let Jonah = BibleBook(type: OldTestament.Jonah.rawValue, bookType: "", bookName: OldTestament.Jonah.bookName, author: "", chapterInfoList: [])
    static let Micah = BibleBook(type: OldTestament.Micah.rawValue, bookType: "", bookName: OldTestament.Micah.bookName, author: "", chapterInfoList: [])
    static let Nahum = BibleBook(type: OldTestament.Nahum.rawValue, bookType: "", bookName: OldTestament.Nahum.bookName, author: "", chapterInfoList: [])
    static let Habakkuk = BibleBook(type: OldTestament.Habakkuk.rawValue, bookType: "", bookName: OldTestament.Habakkuk.bookName, author: "", chapterInfoList: [])
    static let Zephaniah = BibleBook(type: OldTestament.Zephaniah.rawValue, bookType: "", bookName: OldTestament.Zephaniah.bookName, author: "", chapterInfoList: [])
    static let Haggai = BibleBook(type: OldTestament.Haggai.rawValue, bookType: "", bookName: OldTestament.Haggai.bookName, author: "", chapterInfoList: [])
    static let Zechariah = BibleBook(type: OldTestament.Zechariah.rawValue, bookType: "", bookName: OldTestament.Zechariah.bookName, author: "", chapterInfoList: [])
    static let Malachi = BibleBook(type: OldTestament.Malachi.rawValue, bookType: "", bookName: OldTestament.Malachi.bookName, author: "", chapterInfoList: [])
    
    static let Matthew = BibleBook(type: NewTestament.Matthew.rawValue, bookType: "", bookName: NewTestament.Matthew.bookName, author: "", chapterInfoList: [])
    static let Mark = BibleBook(type: NewTestament.Mark.rawValue, bookType: "", bookName: NewTestament.Mark.bookName, author: "", chapterInfoList: [])
    static let Luke = BibleBook(type: NewTestament.Luke.rawValue, bookType: "", bookName: NewTestament.Luke.bookName, author: "", chapterInfoList: [])
    static let John = BibleBook(type: NewTestament.John.rawValue, bookType: "", bookName: NewTestament.John.bookName, author: "", chapterInfoList: [])
    static let ActsOfTheApostles = BibleBook(type: NewTestament.ActsOfTheApostles.rawValue, bookType: "", bookName: NewTestament.ActsOfTheApostles.bookName, author: "", chapterInfoList: [])
    static let Romans = BibleBook(type: NewTestament.Romans.rawValue, bookType: "", bookName: NewTestament.Romans.bookName, author: "", chapterInfoList: [])
    static let CorinthiansOne = BibleBook(type: NewTestament.CorinthiansOne.rawValue, bookType: "", bookName: NewTestament.CorinthiansOne.bookName, author: "", chapterInfoList: [])
    static let CorinthiansTwo = BibleBook(type: NewTestament.CorinthiansTwo.rawValue, bookType: "", bookName: NewTestament.CorinthiansTwo.bookName, author: "", chapterInfoList: [])
    static let Galatians = BibleBook(type: NewTestament.Galatians.rawValue, bookType: "", bookName: NewTestament.Galatians.bookName, author: "", chapterInfoList: [])
    static let Ephesians = BibleBook(type: NewTestament.Ephesians.rawValue, bookType: "", bookName: NewTestament.Ephesians.bookName, author: "", chapterInfoList: [])
    static let Philippians = BibleBook(type: NewTestament.Philippians.rawValue, bookType: "", bookName: NewTestament.Philippians.bookName, author: "", chapterInfoList: [])
    static let Colossians = BibleBook(type: NewTestament.Colossians.rawValue, bookType: "", bookName: NewTestament.Colossians.bookName, author: "", chapterInfoList: [])
    static let ThessaloniansOne = BibleBook(type: NewTestament.ThessaloniansOne.rawValue, bookType: "", bookName: NewTestament.ThessaloniansOne.bookName, author: "", chapterInfoList: [])
    static let ThessaloniansTwo = BibleBook(type: NewTestament.ThessaloniansTwo.rawValue, bookType: "", bookName: NewTestament.ThessaloniansTwo.bookName, author: "", chapterInfoList: [])
    static let TimothyOne = BibleBook(type: NewTestament.TimothyOne.rawValue, bookType: "", bookName: NewTestament.TimothyOne.bookName, author: "", chapterInfoList: [])
    static let TimothyTwo = BibleBook(type: NewTestament.TimothyTwo.rawValue, bookType: "", bookName: NewTestament.TimothyTwo.bookName, author: "", chapterInfoList: [])
    static let Titus = BibleBook(type: NewTestament.Titus.rawValue, bookType: "", bookName: NewTestament.Titus.bookName, author: "", chapterInfoList: [])
    static let Philemon = BibleBook(type: NewTestament.Philemon.rawValue, bookType: "", bookName: NewTestament.Philemon.bookName, author: "", chapterInfoList: [])
    static let Hebrews = BibleBook(type: NewTestament.Hebrews.rawValue, bookType: "", bookName: NewTestament.Hebrews.bookName, author: "", chapterInfoList: [])
    static let James = BibleBook(type: NewTestament.James.rawValue, bookType: "", bookName: NewTestament.James.bookName, author: "", chapterInfoList: [])
    static let PeterOne = BibleBook(type: NewTestament.PeterOne.rawValue, bookType: "", bookName: NewTestament.PeterOne.bookName, author: "", chapterInfoList: [])
    static let PeterTwo = BibleBook(type: NewTestament.PeterTwo.rawValue, bookType: "", bookName: NewTestament.PeterTwo.bookName, author: "", chapterInfoList: [])
    static let JohnOne = BibleBook(type: NewTestament.JohnOne.rawValue, bookType: "", bookName: NewTestament.JohnOne.bookName, author: "", chapterInfoList: [])
    static let JohnTwo = BibleBook(type: NewTestament.JohnTwo.rawValue, bookType: "", bookName: NewTestament.JohnTwo.bookName, author: "", chapterInfoList: [])
    static let JohnThree = BibleBook(type: NewTestament.JohnThree.rawValue, bookType: "", bookName: NewTestament.JohnThree.bookName, author: "", chapterInfoList: [])
    static let Jude = BibleBook(type: NewTestament.Jude.rawValue, bookType: "", bookName: NewTestament.Jude.bookName, author: "", chapterInfoList: [])
    static let Revelation = BibleBook(type: NewTestament.Revelation.rawValue, bookType: "", bookName: NewTestament.Revelation.bookName, author: "", chapterInfoList: [])
        
}

struct BibleBook: Codable {
    let type: Int
    let bookType: String
    let bookName: String
    let author: String
    let chapterInfoList: [BibleChapterInfo]
    
    enum CodingKeys: String, CodingKey {
        case type
        case bookType = "book_type"
        case bookName = "book_name"
        case author
        case chapterInfoList = "chapter_info_list"
    }
}

struct BibleChapterInfo: Codable {
    let chapter: Int
    let verseCount: Int
    
    enum CodingKeys: String, CodingKey {
        case chapter
        case verseCount = "verse_count"
    }
}

