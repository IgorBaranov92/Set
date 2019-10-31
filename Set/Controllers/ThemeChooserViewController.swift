import UIKit

class ThemeChooserViewController: UIViewController {
    
    private let themes : [String:(emoji:String,cardColor:UIColor,backgroundColor:UIColor)] = [
           "Halloween":
            ("🤡😈👿👹👺💀☠️👻👽👾🤖🦇🦉🕷🕸🥀🍫🍬🍭🎃🔮🎭🕯🗡⛓⚰️⚱️",#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
           "Sport" : ("⚽⚾🏀🏐🏈🏉⛹🤾🥎🏏🏑🏒🥅🥍🏓🎾🏸🥊🥋🤺🤼🏃🏇🏋🏹🤸🤹🛹🥏🎳🏊🏄🤽🎿⛸⛷🏂🛷🥌🏌⛳🧭⛺🎣🧗",#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)) ,
           "Transport" :
               ("✈️⛵🚤🚣🚀🚁🚂🚊🚅🚃🚎🚌🚍🚙🚘🚗🚕🚖🚛🚚🚓🚔🚒🚑🚐🚲🚡🚟🚠🚜", #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
           "Animal": ("🐶🐺🐱🐭🐹🐰🐸🐯🐨🐻🐷🐮🐗🐵🐒🐴🐑🐘🐼🐧🐦🐤🐥🐣🐔🐍🐢🐛🐝🐜🐞🐌🐙🐚🐠🐟🐬🐳🐋🐄🐏🐀🐃🐅🐇🐉🐎🐐🐓🐕🐖🐁🐂🐲🐡🐊🐫🐪🐆🐈🐩",#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),#colorLiteral(red: 0.8306297664, green: 1, blue: 0.7910112419, alpha: 1)) ,
           "Food":("☕🍵🍶🍼🍺🍻🍸🍹🍷🍴🍕🍔🍟🍗🍖🍝🍛🍤🍱🍣🍥🍙🍘🍚🍜🍲🍢🍡🍳🍞🍩🍮🍦🍨🍧🎂🍰🍪🍫🍬🍭🍯",#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1),#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1) ),
           "Clothes"
               : ("🎩👑👒👟👞👡👠👢👕👔👚👗🎽👖👘👙💼👜👝👛👓🎀🌂💄",#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.7650054947, blue: 0.8981300767, alpha: 1)),
           "Objects"
               : ("🔧⚒⛏🔩⚙🧲⚖💎💰📡⏰☎🔑🗝🧪🧬💊🧸📦✏🔗📐🔒📍✂",#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.9678710938, green: 0.9678710938, blue: 0.9678710938, alpha: 1))
       ]
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "concentrationGame", let destination = segue.destination.content as? ConcentrationViewController , let themeName = (sender as? UIButton)?.currentTitle {
            let currentTheme = themes[themeName]
            destination.theme = currentTheme
            destination.themeName = themeName
        }
    }
    
    
}



