import numpy as np
import cv2
from scipy.misc import imread, imresize, imsave
import hickle as hkl

def load_data():
    # load your data using this function
    d = hkl.load("../../foodtag/dataset/myfood10-227.hkl")
    data = d['trainFeatures']
    labels = d['trainLabels']
    lz = d['labels']
    data = data.reshape(data.shape[0], 3, 227, 227)
    #data = data.transpose(0, 2, 3, 1)
    return data,labels,lz

def preprocess_image(image):
    im = imresize(image, (224,224))
    r = im[:,:,0].flatten() #Slicing to get R data
    g = im[:,:,1].flatten() #Slicing to get G data
    b = im[:,:,2].flatten() #Slicing to get B data
    new_arry = np.array([[r] + [g] + [b]], np.uint8)
    new_arry = new_arry.reshape(data.shape[0], 3, 227, 227)
    print new_arry.shape
    return im


def preprocess_image_batch(image_paths, img_size=None, crop_size=None, color_mode="rgb", out=None):
    img_list = []

    for im_path in image_paths:
        img = imread(im_path, mode='RGB')
        if img_size:
            img = imresize(img,img_size)

        img = img.astype('float32')
        # We normalize the colors (in RGB space) with the empirical means on the training set
        img[:, :, 0] -= 123.68
        img[:, :, 1] -= 116.779
        img[:, :, 2] -= 103.939
        # We permute the colors to get them in the BGR order
        if color_mode=="bgr":
            img[:,:,[0,1,2]] = img[:,:,[2,1,0]]
        img = img.transpose((2, 0, 1))

        if crop_size:
            img = img[:,(img_size[0]-crop_size[0])//2:(img_size[0]+crop_size[0])//2
                      ,(img_size[1]-crop_size[1])//2:(img_size[1]+crop_size[1])//2]

        img_list.append(img)

    try:
        img_batch = np.stack(img_list, axis=0)
    except:
        raise ValueError('when img_size and crop_size are None, images'
                ' in image_paths must have the same shapes.')

    if out is not None and hasattr(out, 'append'):
        out.append(img_batch)
    else:
        return img_batch

def deprocess_image(image):
    im = np.copy(image)
    im[:,:,0] += 103.939
    im[:,:,1] += 116.779
    im[:,:,2] += 123.

    im = im.transpose((1,2,0))

    return im

def decode_label(index):
    labels = ["Murukku","MeeHoonKueh","BuburPedas","Nasikandar","Mangosteen","KuihDadar","BingkaUbi","CharSiu","Sataycelup",
    "Kangkung","Cendol","SeriMuka","CheeCheongFun","Bakkukteh","Chweekueh","KuihLapis","DurianCrepe",
    "Lemang","OysterOmelette","AngKuKueh","RotiJohn","Huatkuih","PisangGoreng","CurryPuff","TomYumSoup",
    "LorMee","PrawnMee","Wonton","MeeGoreng","IkanBakar","Wajik","AisKacang","Nasipattaya","Keklapis","ChaiTowKuay",
    "SambalUdang","Puri","Lekor","PutuPiring","Murtabak","Buburchacha","Asamlaksa","TangYuan","NasiGorengKampung",
    "PutuMayam","PineappleTart","Bazhang","MeeSiam","Satay","CharKuehTiao","Thosai","Bahulu","Youtiao","Otakotak","Guava",
    "FishHeadCurry","Dodol","LepatPisang","Ketupat","YongTauFu","Yusheng","TauhuSumbat","TauFooFah","HokkienMee","BeefRendang",
    "Prawnsambal","NasiImpit","SambalPetai","CucurUdang","RotiCanai","Durian","KayaToast","MeeRebus","ApamBalik","BananaLeafRice",
    "Capati","Popiah","ClayPotRice","WaTanHo","MeeJawa","RotiNaan","KuihSeriMuka","ChiliCrab","HainaneseChickenRice","Rambutan","Nasilemak",
    "PanMee","WanTanMee","OndehOndeh","CurryLaksa","MaggiGoreng","RotiTissue","Rojak","TandooriChicken","MeeRojak","SotoAyam","MeeHoonSoup",
    "Langsat","YamCake","RotiJala"]
    return labels[index]
