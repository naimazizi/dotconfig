function layout() {
  return {
    name: "Center or Tall",
    getFrameAssignments: (windows, screenFrame) => {
      if (windows.length === 1) {
        // Single window: centered on screen at 90% of screen dimensions
        const windowWidth = screenFrame.width * 0.9;
        const windowHeight = screenFrame.height * 0.9;
        const offsetX = screenFrame.x + (screenFrame.width - windowWidth) / 2;
        const offsetY = screenFrame.y + (screenFrame.height - windowHeight) / 2;

        const frame = {
          x: offsetX,
          y: offsetY,
          width: windowWidth,
          height: windowHeight,
        };

        return { [windows[0].id]: frame };
      } else {
        // Multiple windows: Widescreen Tall Left layout
        const mainWidth = screenFrame.width * 0.6;
        const tallWidth = screenFrame.width * 0.4;
        const tallOffsetX = screenFrame.x;
        const mainOffsetX = screenFrame.x + tallWidth;

        const frames = windows.map((window, index) => {
          if (index === 0) {
            // First window takes the right 60% of the screen
            const frame = {
              x: mainOffsetX,
              y: screenFrame.y,
              width: mainWidth,
              height: screenFrame.height,
            };
            return { [window.id]: frame };
          } else {
            // Remaining windows stack vertically on the left 40%
            const remainingWindows = windows.length - 1;
            const windowHeight = screenFrame.height / remainingWindows;
            const offsetY = screenFrame.y + (index - 1) * windowHeight;

            const frame = {
              x: tallOffsetX,
              y: offsetY,
              width: tallWidth,
              height: windowHeight,
            };
            return { [window.id]: frame };
          }
        });

        return frames.reduce((acc, frame) => ({ ...acc, ...frame }), {});
      }
    },
  };
}
