import UIKit

class ThemeChooserViewController: UIViewController {
    
    private let themes : [String:(emoji:String,cardColor:UIColor,backgroundColor:UIColor)] = [
           "Halloween":
            ("🤡😈👿👹👺💀☠️👻👽👾🤖🦇🦉🕷🕸🥀🍫🍬🍭🎃🔮🎭🕯🗡⛓⚰️⚱️",.orange,.black),
           "Sport" : ("⚽⚾🏀🏐🏈🏉⛹🤾🥎🏏🏑🏒🥅🥍🏓🎾🏸🥊🥋🤺🤼🏃🏇🏋🏹🤸🤹🛹🥏🎳🏊🏄🤽🎿⛸⛷🏂🛷🥌🏌⛳🧭⛺🎣🧗",#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)) ,
           "Transport" :
               ("✈️⛵🚤🚣🚀🚁🚂🚊🚅🚃🚎🚌🚍🚙🚘🚗🚕🚖🚛🚚🚓🚔🚒🚑🚐🚲🚡🚟🚠🚜", #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)),
           "Animal": ("🐶🐺🐱🐭🐹🐰🐸🐯🐨🐻🐷🐮🐗🐵🐒🐴🐑🐘🐼🐧🐦🐤🐥🐣🐔🐍🐢🐛🐝🐜🐞🐌🐙🐚🐠🐟🐬🐳🐋🐄🐏🐀🐃🐅🐇🐉🐎🐐🐓🐕🐖🐁🐂🐲🐡🐊🐫🐪🐆🐈🐩",#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)) ,
           "Food":("☕🍵🍶🍼🍺🍻🍸🍹🍷🍴🍕🍔🍟🍗🍖🍝🍛🍤🍱🍣🍥🍙🍘🍚🍜🍲🍢🍡🍳🍞🍩🍮🍦🍨🍧🎂🍰🍪🍫🍬🍭🍯",#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) ),
           "Clothes"
               : ("🎩👑👒👟👞👡👠👢👕👔👚👗🎽👖👘👙💼👜👝👛👓🎀🌂💄",#colorLiteral(red: 1, green: 0.9343929875, blue: 0.198782138, alpha: 1),#colorLiteral(red: 0.8634200508, green: 0.5382388225, blue: 0.234448747, alpha: 1))
       ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "concentrationGame", let destination = segue.destination.content as? ConcentrationViewController , let themeName = (sender as? UIButton)?.currentTitle {
            let currentTheme = themes[themeName]
            destination.theme = currentTheme
            destination.themeName = themeName
        }
    }
    
    
}



