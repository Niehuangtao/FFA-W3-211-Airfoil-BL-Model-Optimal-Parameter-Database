from pathlib import Path
from math import atan2, cos, sin

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "docs" / "assets"
ASSETS.mkdir(parents=True, exist_ok=True)

FONT_CANDIDATES = [
    Path(r"C:\Windows\Fonts\simhei.ttf"),
    Path(r"C:\Windows\Fonts\NotoSansSC-VF.ttf"),
    Path(r"C:\Windows\Fonts\msyh.ttc"),
    Path(r"C:\Windows\Fonts\simsun.ttc"),
]
FONT_PATH = next((path for path in FONT_CANDIDATES if path.exists()), None)
if FONT_PATH is None:
    raise FileNotFoundError("No Chinese font found in C:\\Windows\\Fonts")

TITLE_FONT = ImageFont.truetype(str(FONT_PATH), 38)
BOX_FONT = ImageFont.truetype(str(FONT_PATH), 27)
NOTE_FONT = ImageFont.truetype(str(FONT_PATH), 22)

INK = "#182B33"
MUTED = "#52606D"
LINE = "#176274"
BOX_FILL = "#F7FBFC"
BOX_OUTLINE = "#176274"


def text_size(draw, text, font):
    box = draw.textbbox((0, 0), text, font=font)
    return box[2] - box[0], box[3] - box[1]


def draw_centered_multiline(draw, xy, text, font=BOX_FONT, fill=INK, line_gap=8):
    x1, y1, x2, y2 = xy
    lines = text.split("\n")
    heights = [text_size(draw, line, font)[1] for line in lines]
    total_h = sum(heights) + line_gap * (len(lines) - 1)
    y = y1 + (y2 - y1 - total_h) / 2
    for line, height in zip(lines, heights):
        width, _ = text_size(draw, line, font)
        draw.text((x1 + (x2 - x1 - width) / 2, y), line, font=font, fill=fill)
        y += height + line_gap


def draw_box(draw, xy, text):
    draw.rounded_rectangle(xy, radius=16, fill=BOX_FILL, outline=BOX_OUTLINE, width=4)
    draw_centered_multiline(draw, xy, text)


def draw_arrow(draw, start, end):
    x1, y1 = start
    x2, y2 = end
    draw.line([start, end], fill=LINE, width=5)
    angle = atan2(y2 - y1, x2 - x1)
    size = 15
    points = [
        (x2, y2),
        (x2 - size * cos(angle - 0.48), y2 - size * sin(angle - 0.48)),
        (x2 - size * cos(angle + 0.48), y2 - size * sin(angle + 0.48)),
    ]
    draw.polygon(points, fill=LINE)


def draw_note(draw, xy, text):
    x, y = xy
    for line in text.split("\n"):
        draw.text((x, y), line, font=NOTE_FONT, fill=MUTED)
        y += 34


def operation_flowchart():
    img = Image.new("RGB", (1500, 880), "white")
    draw = ImageDraw.Draw(img)
    draw.text((60, 50), "BLPO 软件使用流程", font=TITLE_FONT, fill=INK)

    boxes = {
        "a": (90, 170, 390, 290, "启动软件\n选择参考数据"),
        "b": (600, 170, 900, 290, "输入翼型运动工况\n均值/幅值/k/Re"),
        "c": (1110, 170, 1410, 290, "预览默认模型\n检查数据范围"),
        "d": (1110, 470, 1410, 590, "运行优化\n查看收敛状态"),
        "e": (600, 470, 900, 590, "查看结果\n曲线/参数/RMSE"),
        "f": (90, 470, 390, 590, "导出结果\nCSV/MAT/PNG"),
    }
    for xy_text in boxes.values():
        draw_box(draw, xy_text[:4], xy_text[4])

    draw_arrow(draw, (390, 230), (600, 230))
    draw_arrow(draw, (900, 230), (1110, 230))
    draw_arrow(draw, (1260, 290), (1260, 470))
    draw_arrow(draw, (1110, 530), (900, 530))
    draw_arrow(draw, (600, 530), (390, 530))

    draw_note(
        draw,
        (90, 710),
        "输入文件支持：试验数据2列（time, Cl）；CFD数据4列（time, Cl, Cd, Cm）。\n"
        "导出文件包括：优化参数、误差指标、对比数据、MAT 结果文件和拟合曲线图。",
    )
    img.save(ASSETS / "flowchart_operation.png")


def algorithm_flowchart():
    img = Image.new("RGB", (1500, 950), "white")
    draw = ImageDraw.Draw(img)
    draw.text((60, 50), "BL 参数优化计算流程", font=TITLE_FONT, fill=INK)

    boxes = {
        "a": (90, 160, 400, 290, "读取用户工况\n生成攻角与q序列"),
        "b": (595, 160, 905, 290, "读取参考数据\n识别2列/4列格式"),
        "c": (1100, 160, 1410, 290, "载入默认BL参数\n和翼型静态参数"),
        "d": (1100, 430, 1410, 560, "调用BL模型\n计算Cl/Cd/Cm"),
        "e": (595, 430, 905, 560, "按时间插值对齐\n计算 RMSE 目标函数"),
        "f": (90, 430, 400, 560, "遗传算法全局搜索\n可选局部优化"),
        "g": (595, 700, 905, 830, "输出最优参数\n生成对比图和指标"),
    }
    for xy_text in boxes.values():
        draw_box(draw, xy_text[:4], xy_text[4])

    draw_arrow(draw, (400, 225), (595, 225))
    draw_arrow(draw, (905, 225), (1100, 225))
    draw_arrow(draw, (1255, 290), (1255, 430))
    draw_arrow(draw, (1100, 495), (905, 495))
    draw_arrow(draw, (595, 495), (400, 495))
    draw_arrow(draw, (245, 560), (595, 765))
    draw_arrow(draw, (750, 560), (750, 700))

    draw_note(
        draw,
        (90, 875),
        "当参考数据为2列时仅以Cl参与拟合；当参考数据为4列时同时以Cl、Cd、Cm构造综合目标。",
    )
    img.save(ASSETS / "flowchart_algorithm.png")


if __name__ == "__main__":
    operation_flowchart()
    algorithm_flowchart()
    print(ASSETS / "flowchart_operation.png")
    print(ASSETS / "flowchart_algorithm.png")
