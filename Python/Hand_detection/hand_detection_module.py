import cv2
import mediapipe as mp

class handDetection():
    def __init__(self, mode=False,maxHands=2,detectionCon=0.5,modelComplexity=1,trackCon=0.5) -> None:
        self.mode=mode
        self.maxHands=maxHands
        self.detectionCon=detectionCon
        self.modelComplex = modelComplexity
        self.trackCon=trackCon
        self.mpHands = mp.solutions.hands
        self.hands=self.mpHands.Hands(self.mode, self.maxHands,self.modelComplex,self.detectionCon, self.trackCon)
        self.mpDraw = mp.solutions.drawing_utils
    def handsFinder(self,image,draw=True):
        imageRGB = cv2.cvtColor(image,cv2.COLOR_BGR2RGB)
        self.results= self.hands.process(imageRGB)

        if self.results.multi_hand_landmarks:
            for hand_lms in self.results.multi_hand_landmarks:
                if draw:
                    self.mpDraw.draw_landmarks(image,hand_lms,self.mpHands.HAND_CONNECTIONS)
        return image
    def positionFinder(self,image,handNo=0):
        lmlist= []
        if self.results.multi_hand_landmarks:
            Hand = self.results.multi_hand_landmarks[handNo]
            for id,lm in enumerate(Hand.landmark):
                height, width = image.shape[:2]
                cx,cy = int(lm.x*width), int(lm.y*height)
                lmlist.append([id,cx,cy])
            
        return lmlist
def main():
    cap = cv2.VideoCapture(0)
    detection = handDetection()
    cap.set(3,10000)
    cap.set(4,10000)
    while True:
        success,image = cap.read()
        image = detection.handsFinder(image)
        lmlist = detection.positionFinder(image)
        if (len(lmlist)!=0):
            print(lmlist[4])
        image = cv2.flip(image,1)
        cv2.imshow('Video',image)
        if cv2.waitKey(1) & 0XFF==ord('q'):
            break

if __name__ =='__main__':
    main()