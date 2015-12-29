
![icon](http://cfile4.uf.tistory.com/image/22348541568283BF1A3886)
  
# [Swiftris](http://hiddenviewer.tistory.com/285)
- Swiftris is a swift version of Tetris game.   
- It has been developed for the study. 
- It's simple but impact. enjoy the game.

  




# 1. Swiftris Video
- [View YouTube Video](https://www.youtube.com/watch?v=iPihhGjGUl4)

![movie](http://cfile2.uf.tistory.com/image/256F5E455682A38006330E)  

# 2.Control of Game    
- Play: Touch a Play button.
- Pause: Touch a Pause button.
- Stop:  Touch a Stop button.

![play](http://cfile23.uf.tistory.com/image/26736A40568284E61EF175) &nbsp;&nbsp; ![pause](http://cfile7.uf.tistory.com/image/212DD44D568284F73EF275)
  

- Move Left: Touch the left side of the brick.
- Move Right: Touch the right side of the brick.
- Rotate : Touch the top side of the brick.
- Drop: Long touch the bottom side of the brick.



# 3. Architecture
- ViewController.swift
- Swiftris.swift
- GameView.swift  
	- GameBoard.swift
	- GameScore.swift
	- NextBrick.swift
	- Brick.swift
- GameTimer.swift
- SoundManager.swift


## GameBoard
- GameBoard is 22 rows by 10 columns, Two-dimensional array of UIColor. 
  
```  
class GameBoard: UIView {
	static let rows = 22
    static let cols = 10
    
    ...
	var board = [[UIColor]]()
	...
}
  
```  

![gameboard](http://cfile1.uf.tistory.com/image/241CD247568285DF1F6D67)



## Brick  
- 7 different types of bricks. I, J, L, T, Z, S, O.
- Brick has a unique color.

```  
enum BrickType {
    case I(UIColor)
    case J(UIColor)
    case L(UIColor)
    case T(UIColor)
    case Z(UIColor)
    case S(UIColor)
    case O(UIColor)
}  
  
class Brick: NSObject {
    
	...
    static var bricks = [
        BrickType.I(UIColor(red:0.40, green:0.64, blue:0.93, alpha:1.0)),
        BrickType.J(UIColor(red:0.31, green:0.42, blue:0.80, alpha:1.0)),
        BrickType.L(UIColor(red:0.81, green:0.47, blue:0.19, alpha:1.0)),
        BrickType.T(UIColor(red:0.67, green:0.45, blue:0.78, alpha:1.0)),
        BrickType.Z(UIColor(red:0.80, green:0.31, blue:0.38, alpha:1.0)),
        BrickType.S(UIColor(red:0.61, green:0.75, blue:0.31, alpha:1.0)),
        BrickType.O(UIColor(red:0.88, green:0.69, blue:0.25, alpha:1.0))
    ]
	...    
}
  
```  

![bricks](http://cfile22.uf.tistory.com/image/22088249568285F527987D)
  
  
  
## Swiftris
- Process game logic and Interaction.

```    
class Swiftris: NSObject {

	...
	
 	// 터치 - 벽돌 왼쪽,오른쪽 이동, 벽돌 드랍 
    func touch(touch:UITouch!) {
        guard self.gameState == GameState.PLAY else { return }
        guard let curretBrick = self.gameView.gameBoard.currentBrick else { return }
        
        let p = touch.locationInView(self.gameView.gameBoard)
        
        let half = self.gameView.gameBoard.centerX
        
        let top  = curretBrick.top()
        let topY = CGFloat( (Int(top.y) + curretBrick.ty) * GameBoard.brickSize )

        if p.y > topY  {
            if p.x > half {
                self.gameView.gameBoard.updateX(1)
            } else if p.x < half {
                self.gameView.gameBoard.updateX(-1)
            }
        } else   {
            self.gameView.gameBoard.rotateBrick()
        }
    }
	
	// 롱프레스 - 벽돌 드랍 
 	func longPressed(longpressGesture:UILongPressGestureRecognizer!) {
        if self.gameState == GameState.PLAY {

            if longpressGesture.state == UIGestureRecognizerState.Began {
                self.gameView.gameBoard.dropBrick()
            }
        }
    }

}
  
```  




## GameScore    
- 게임점수는 클리어되는 라인수에 따라 10점, 30점, 60점, 100점이 지급됩니다.    
- 예제에서는 레벨클리어 기능을 제공하지 않았지만, 자신만의 레벨클리어 기능을 구현해보세요.

```    

class GameScore: UIView {

	...
    var scores = [0, 10, 30, 60, 100]  
    
    func lineClear(noti:NSNotification!) {
        if let userInfo = noti.userInfo as? [String:NSNumber] {
            if let lineCount = userInfo["lineCount"] {
                self.lineClearCount += lineCount.integerValue
                self.gameScore += self.scores[lineCount.integerValue]
                self.update()
            }
        }
    }
    
    ...
}
    
  
```  


![scores](http://cfile26.uf.tistory.com/image/237E4D4C56828629180256)
  
## NextBrick  
- You can see the next three bricks that can be used to play in advance.
  
![nextbricks](http://cfile28.uf.tistory.com/image/23503C50568286632A920D)
  
```    
class Brick: NSObject {
	...
	static var nextBricks = [Brick]()
    static var nextBrickCount = 3
    
    // 벽돌 대기열에서 첫번째(index 0) 벽돌을 사용하고, 대기열을 3개로 채웁니다.
    static func generate() -> Brick! {
        while self.nextBricks.count < self.nextBrickCount {
            self.nextBricks.append(self.newBrick())
        }
        let brick = self.nextBricks.removeAtIndex(0)
        self.nextBricks.append(self.newBrick())
        return brick
    }
    ...

}
  
```  


## SoundManager   
- Provides some sound effects .
- Background Music, Falling brick sound, Game over sound.
  
```    
class SoundManager: NSObject {
   
    var bgmPlayer:AVAudioPlayer?
    var effectPlayer:AVAudioPlayer?
    var gameOverPlayer:AVAudioPlayer?
    ...
}
  
```  


# 4. Feedback  
-  If you have any questions, please leave a message.
- [hiddenviewer@gmail.com](hiddenviewer@gmail.com)



# 5. License
Swiftris is released under the MIT license. See LICENSE for details.


