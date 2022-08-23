//
//  Bible.swift
//  Moyang
//
//  Created by kibo on 2022/08/23.
//

import Foundation

class BibleInfo {
    enum Old: Int {
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
    
    enum New: Int {
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
    static let Genesis = BibleBookInfo(type: Old.Genesis.rawValue, category: "", bookName: Old.Genesis.bookName, author: "",
                                       chapterCount: [31,25,24,26,32,22,24,22,29,32,
                                                      32,20,18,24,21,16,27,33,38,18,
                                                      34,24,20,67,34,35,46,22,35,43,
                                                      55,32,20,31,29,43,36,30,23,23,
                                                      57,38,34,34,28,34,31,22,33,26])
    static let Exodus = BibleBookInfo(type: Old.Exodus.rawValue, category: "", bookName: Old.Exodus.bookName, author: "",
                                      chapterCount: [22,25,22,31,23,30,25,32,35,29,
                                                     10,51,22,31,27,36,16,27,25,26,
                                                     36,31,33,18,40,37,21,43,46,38,
                                                     18,35,23,35,35,38,29,31,43,38])
    static let Leviticus = BibleBookInfo(type: Old.Leviticus.rawValue, category: "", bookName: Old.Leviticus.bookName, author: "",
                                         chapterCount: [17,16,17,35,19,30,38,36,24,20,
                                                        47,8,59,57,33,34,16,30,37,27,
                                                        24,33,44,23,55,46,34])
    static let Numbers = BibleBookInfo(type: Old.Numbers.rawValue, category: "", bookName: Old.Numbers.bookName, author: "",
                                       chapterCount: [54,34,51,49,31,27,89,26,23,36,
                                                      35,16,33,45,41,50,13,32,22,29,
                                                      35,41,30,25,18,65,23,31,40,16,
                                                      54,42,56,29,34,13])
    static let Deuteronomy = BibleBookInfo(type: Old.Deuteronomy.rawValue, category: "", bookName: Old.Deuteronomy.bookName, author: "",
                                           chapterCount: [46,37,29,49,33,25,26,20,29,22,
                                                          32,32,18,29,23,22,20,22,21,20,
                                                          23,30,25,22,19,19,26,68,29,20,
                                                          30,52,29,12])
    static let Joshua = BibleBookInfo(type: Old.Joshua.rawValue, category: "", bookName: Old.Joshua.bookName, author: "",
                                      chapterCount: [18,24,17,24,15,27,26,35,27,43,
                                                     23,24,33,15,63,10,18,28,51,9,
                                                     45,34,16,33])
    static let Judges = BibleBookInfo(type: Old.Judges.rawValue, category: "", bookName: Old.Judges.bookName, author: "",
                                      chapterCount: [36,23,31,24,31,40,25,35,57,18,
                                                     40,15,25,20,20,31,13,31,30,48,
                                                     25])
    static let Ruth = BibleBookInfo(type: Old.Ruth.rawValue, category: "", bookName: Old.Ruth.bookName, author: "",
                                    chapterCount: [22,23,18,22])
    static let SamuelOne = BibleBookInfo(type: Old.SamuelOne.rawValue, category: "", bookName: Old.SamuelOne.bookName, author: "",
                                         chapterCount: [28,36,21,22,12,21,17,22,27,27,
                                                        15,25,23,52,35,23,58,30,24,42,
                                                        15,23,29,22,44,25,12,25,11,31,
                                                        13])
    static let SamuelTwo = BibleBookInfo(type: Old.SamuelTwo.rawValue, category: "", bookName: Old.SamuelTwo.bookName, author: "",
                                         chapterCount: [27,32,39,12,25,23,29,18,13,19,
                                                        27,31,39,33,37,23,29,33,43,26,
                                                        22,51,39,25])
    static let KingsOne = BibleBookInfo(type: Old.KingsOne.rawValue, category: "", bookName: Old.KingsOne.bookName, author: "",
                                        chapterCount: [53,46,28,34,18,38,51,66,28,29,
                                                       43,33,34,31,34,34,24,46,21,43,
                                                       29,53])
    static let KingsTow = BibleBookInfo(type: Old.KingsTow.rawValue, category: "", bookName: Old.KingsTow.bookName, author: "",
                                        chapterCount: [])
    static let ChroniclesOne = BibleBookInfo(type: Old.ChroniclesOne.rawValue, category: "", bookName: Old.ChroniclesOne.bookName, author: "",
                                             chapterCount: [])
    static let ChroniclesTwo = BibleBookInfo(type: Old.ChroniclesTwo.rawValue, category: "", bookName: Old.ChroniclesTwo.bookName, author: "",
                                             chapterCount: [])
    static let Ezra = BibleBookInfo(type: Old.Ezra.rawValue, category: "", bookName: Old.Ezra.bookName, author: "",
                                    chapterCount: [])
    static let Nehemiah = BibleBookInfo(type: Old.Nehemiah.rawValue, category: "", bookName: Old.Nehemiah.bookName, author: "",
                                        chapterCount: [])
    static let Esther = BibleBookInfo(type: Old.Esther.rawValue, category: "", bookName: Old.Esther.bookName, author: "",
                                      chapterCount: [])
    static let Job = BibleBookInfo(type: Old.Job.rawValue, category: "", bookName: Old.Job.bookName, author: "",
                                   chapterCount: [])
    static let Psalms = BibleBookInfo(type: Old.Psalms.rawValue, category: "", bookName: Old.Psalms.bookName, author: "",
                                      chapterCount: [])
    static let Proverbs = BibleBookInfo(type: Old.Proverbs.rawValue, category: "", bookName: Old.Proverbs.bookName, author: "",
                                        chapterCount: [])
    static let Ecclesiastes = BibleBookInfo(type: Old.Ecclesiastes.rawValue, category: "", bookName: Old.Ecclesiastes.bookName, author: "",
                                            chapterCount: [])
    static let SongOfSongs = BibleBookInfo(type: Old.SongOfSongs.rawValue, category: "", bookName: Old.SongOfSongs.bookName, author: "",
                                           chapterCount: [])
    static let Isaiah = BibleBookInfo(type: Old.Isaiah.rawValue, category: "", bookName: Old.Isaiah.bookName, author: "",
                                      chapterCount: [])
    static let Jeremiah = BibleBookInfo(type: Old.Jeremiah.rawValue, category: "", bookName: Old.Jeremiah.bookName, author: "",
                                        chapterCount: [])
    static let Lamentations = BibleBookInfo(type: Old.Lamentations.rawValue, category: "", bookName: Old.Lamentations.bookName, author: "",
                                            chapterCount: [])
    static let Ezekiel = BibleBookInfo(type: Old.Ezekiel.rawValue, category: "", bookName: Old.Ezekiel.bookName, author: "",
                                       chapterCount: [])
    static let Daniel = BibleBookInfo(type: Old.Daniel.rawValue, category: "", bookName: Old.Daniel.bookName, author: "",
                                      chapterCount: [])
    static let Hosea = BibleBookInfo(type: Old.Hosea.rawValue, category: "", bookName: Old.Hosea.bookName, author: "",
                                     chapterCount: [])
    static let Joel = BibleBookInfo(type: Old.Joel.rawValue, category: "", bookName: Old.Joel.bookName, author: "",
                                    chapterCount: [])
    static let Amos = BibleBookInfo(type: Old.Amos.rawValue, category: "", bookName: Old.Amos.bookName, author: "",
                                    chapterCount: [])
    static let Obadiah = BibleBookInfo(type: Old.Obadiah.rawValue, category: "", bookName: Old.Obadiah.bookName, author: "",
                                       chapterCount: [])
    static let Jonah = BibleBookInfo(type: Old.Jonah.rawValue, category: "", bookName: Old.Jonah.bookName, author: "",
                                     chapterCount: [])
    static let Micah = BibleBookInfo(type: Old.Micah.rawValue, category: "", bookName: Old.Micah.bookName, author: "",
                                     chapterCount: [])
    static let Nahum = BibleBookInfo(type: Old.Nahum.rawValue, category: "", bookName: Old.Nahum.bookName, author: "",
                                     chapterCount: [])
    static let Habakkuk = BibleBookInfo(type: Old.Habakkuk.rawValue, category: "", bookName: Old.Habakkuk.bookName, author: "",
                                        chapterCount: [])
    static let Zephaniah = BibleBookInfo(type: Old.Zephaniah.rawValue, category: "", bookName: Old.Zephaniah.bookName, author: "",
                                         chapterCount: [])
    static let Haggai = BibleBookInfo(type: Old.Haggai.rawValue, category: "", bookName: Old.Haggai.bookName, author: "",
                                      chapterCount: [])
    static let Zechariah = BibleBookInfo(type: Old.Zechariah.rawValue, category: "", bookName: Old.Zechariah.bookName, author: "",
                                         chapterCount: [])
    static let Malachi = BibleBookInfo(type: Old.Malachi.rawValue, category: "", bookName: Old.Malachi.bookName, author: "",
                                       chapterCount: [])
    
    static let Matthew = BibleBookInfo(type: New.Matthew.rawValue, category: "", bookName: New.Matthew.bookName, author: "",
                                       chapterCount: [])
    static let Mark = BibleBookInfo(type: New.Mark.rawValue, category: "", bookName: New.Mark.bookName, author: "",
                                    chapterCount: [])
    static let Luke = BibleBookInfo(type: New.Luke.rawValue, category: "", bookName: New.Luke.bookName, author: "",
                                    chapterCount: [])
    static let John = BibleBookInfo(type: New.John.rawValue, category: "", bookName: New.John.bookName, author: "",
                                    chapterCount: [])
    static let ActsOfTheApostles = BibleBookInfo(type: New.ActsOfTheApostles.rawValue, category: "", bookName: New.ActsOfTheApostles.bookName, author: "",
                                                 chapterCount: [])
    static let Romans = BibleBookInfo(type: New.Romans.rawValue, category: "", bookName: New.Romans.bookName, author: "",
                                      chapterCount: [])
    static let CorinthiansOne = BibleBookInfo(type: New.CorinthiansOne.rawValue, category: "", bookName: New.CorinthiansOne.bookName, author: "",
                                              chapterCount: [])
    static let CorinthiansTwo = BibleBookInfo(type: New.CorinthiansTwo.rawValue, category: "", bookName: New.CorinthiansTwo.bookName, author: "",
                                              chapterCount: [])
    static let Galatians = BibleBookInfo(type: New.Galatians.rawValue, category: "", bookName: New.Galatians.bookName, author: "",
                                         chapterCount: [])
    static let Ephesians = BibleBookInfo(type: New.Ephesians.rawValue, category: "", bookName: New.Ephesians.bookName, author: "",
                                         chapterCount: [])
    static let Philippians = BibleBookInfo(type: New.Philippians.rawValue, category: "", bookName: New.Philippians.bookName, author: "",
                                           chapterCount: [])
    static let Colossians = BibleBookInfo(type: New.Colossians.rawValue, category: "", bookName: New.Colossians.bookName, author: "",
                                          chapterCount: [])
    static let ThessaloniansOne = BibleBookInfo(type: New.ThessaloniansOne.rawValue, category: "", bookName: New.ThessaloniansOne.bookName, author: "",
                                                chapterCount: [])
    static let ThessaloniansTwo = BibleBookInfo(type: New.ThessaloniansTwo.rawValue, category: "", bookName: New.ThessaloniansTwo.bookName, author: "",
                                                chapterCount: [])
    static let TimothyOne = BibleBookInfo(type: New.TimothyOne.rawValue, category: "", bookName: New.TimothyOne.bookName, author: "",
                                          chapterCount: [])
    static let TimothyTwo = BibleBookInfo(type: New.TimothyTwo.rawValue, category: "", bookName: New.TimothyTwo.bookName, author: "",
                                          chapterCount: [])
    static let Titus = BibleBookInfo(type: New.Titus.rawValue, category: "", bookName: New.Titus.bookName, author: "",
                                     chapterCount: [])
    static let Philemon = BibleBookInfo(type: New.Philemon.rawValue, category: "", bookName: New.Philemon.bookName, author: "",
                                        chapterCount: [])
    static let Hebrews = BibleBookInfo(type: New.Hebrews.rawValue, category: "", bookName: New.Hebrews.bookName, author: "",
                                       chapterCount: [])
    static let James = BibleBookInfo(type: New.James.rawValue, category: "", bookName: New.James.bookName, author: "",
                                     chapterCount: [])
    static let PeterOne = BibleBookInfo(type: New.PeterOne.rawValue, category: "", bookName: New.PeterOne.bookName, author: "",
                                        chapterCount: [])
    static let PeterTwo = BibleBookInfo(type: New.PeterTwo.rawValue, category: "", bookName: New.PeterTwo.bookName, author: "",
                                        chapterCount: [])
    static let JohnOne = BibleBookInfo(type: New.JohnOne.rawValue, category: "", bookName: New.JohnOne.bookName, author: "",
                                       chapterCount: [])
    static let JohnTwo = BibleBookInfo(type: New.JohnTwo.rawValue, category: "", bookName: New.JohnTwo.bookName, author: "",
                                       chapterCount: [])
    static let JohnThree = BibleBookInfo(type: New.JohnThree.rawValue, category: "", bookName: New.JohnThree.bookName, author: "",
                                         chapterCount: [])
    static let Jude = BibleBookInfo(type: New.Jude.rawValue, category: "", bookName: New.Jude.bookName, author: "",
                                    chapterCount: [])
    static let Revelation = BibleBookInfo(type: New.Revelation.rawValue, category: "", bookName: New.Revelation.bookName, author: "",
                                          chapterCount: [])
        
}

struct BibleBookInfo: Codable {
    let type: Int
    let category: String
    let bookName: String
    let author: String
    let chapterCount: [Int]
    
    enum CodingKeys: String, CodingKey {
        case type
        case category = "category"
        case bookName = "book_name"
        case author
        case chapterCount = "chapter_count"
    }
}
